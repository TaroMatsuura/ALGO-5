from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import torch
from sqlalchemy import text

from inference_win5 import (
    apply_scaler_from_history,
    build_auto_selected_daily_patterns,
    build_expected_value_threshold_grid,
    build_probability_threshold_grid,
    build_topn_patterns,
    evaluate_win5_patterns,
    load_backtest_dataframe,
    load_checkpoints,
    load_race_schedule_metadata,
    parse_ensemble_weights,
    score_races,
    validate_checkpoint_compatibility,
)
from jravan_dataframe_extractor import JravanDataFrameExtractor
from win5_resnet_model import build_win5_resnet_model


@dataclass(frozen=True)
class StrategyConfig:
    name: str
    selection_mode: str
    score_mode: str
    dense_odds_variance_threshold: float | None
    cliff_odds_ratio_threshold: float | None
    min_ticket_count: int | None
    max_ticket_count: int | None
    min_wide_legs: int | None
    max_wide_legs: int | None
    min_single_legs: int | None
    max_leg_top_n: int | None
    require_wide_legs_on_dense: bool


def load_win5_payouts_from_db(start_date: str, end_date: str) -> pd.DataFrame:
    extractor = JravanDataFrameExtractor(env_path=".env", database_name="jravantest")
    query = text(
        """
        SELECT
            STR_TO_DATE(CONCAT(Year, MonthDay), '%Y%m%d') AS race_date,
            MAX(CAST(PayJyushosiki AS UNSIGNED)) AS payout_yen
        FROM N_JYUSYOSIKI
        WHERE STR_TO_DATE(CONCAT(Year, MonthDay), '%Y%m%d') BETWEEN :start_date AND :end_date
        GROUP BY STR_TO_DATE(CONCAT(Year, MonthDay), '%Y%m%d')
        ORDER BY race_date
        """
    )
    try:
        with extractor._engine.connect() as connection:
            payouts = pd.read_sql_query(
                query,
                connection,
                params={"start_date": start_date, "end_date": end_date},
            )
    finally:
        extractor.close()
    payouts["race_date"] = pd.to_datetime(payouts["race_date"], errors="coerce")
    return payouts


def build_models(checkpoints: list[dict[str, object]], feature_columns: list[str]) -> list[torch.nn.Module]:
    models: list[torch.nn.Module] = []
    for checkpoint in checkpoints:
        config = checkpoint["config"]
        model = build_win5_resnet_model(
            input_dim=int(config.get("input_dim", len(feature_columns))),
            num_classes=int(config.get("num_classes", 18)),
            hidden_dim=int(config.get("hidden_dim", 256)),
            num_blocks=int(config.get("num_blocks", 4)),
            dropout=float(config.get("dropout", 0.1)),
            device="cpu",
        )
        model.load_state_dict(checkpoint["model_state_dict"])
        models.append(model)
    return models


def evaluate_for_date(
    target_date: str,
    payouts_for_date: pd.DataFrame,
    dataframe: pd.DataFrame,
    feature_columns: list[str],
    standardize_features: bool,
    models: list[torch.nn.Module],
    ensemble_weights: list[float],
) -> dict[str, pd.DataFrame]:
    scaled = apply_scaler_from_history(
        dataframe=dataframe.copy(),
        feature_columns=feature_columns,
        race_date_col="race_date",
        backtest_start_date=target_date,
        standardize_features=standardize_features,
    )
    day_start = pd.Timestamp(target_date)
    evaluation_dataframe = scaled.loc[scaled["race_date"].between(day_start, day_start)].copy()
    scored = score_races(
        dataframe=evaluation_dataframe,
        models=models,
        ensemble_weights=ensemble_weights,
        feature_columns=feature_columns,
        race_date_col="race_date",
        device=torch.device("cpu"),
    )
    schedule_dataframe = load_race_schedule_metadata(start_date=day_start, end_date=day_start)
    _, daily_results, _ = evaluate_win5_patterns(
        scored_dataframe=scored,
        race_date_col="race_date",
        selection_mode="jra_win5_rule",
        min_race_num=10,
        required_races=5,
        topn_patterns=build_topn_patterns(3, None, "1,2,3,4,5", 5),
        ticket_unit=100,
        probability_thresholds=build_probability_threshold_grid(0.0, None, None),
        schedule_dataframe=schedule_dataframe,
        payout_dataframe=payouts_for_date,
        min_expected_values=build_expected_value_threshold_grid(0.0, None, None),
        buy_expected_value_source="estimated",
        max_probability_sum=None,
        max_bet_amount=10000,
        max_market_rank=10,
        dynamic_topn_enabled=False,
        dynamic_topn_threshold=0.05,
        dynamic_topn_max=6,
    )
    return daily_results


def select_strategy_row(daily_results: dict[str, pd.DataFrame], config: StrategyConfig) -> pd.Series:
    selected = build_auto_selected_daily_patterns(
        daily_results=daily_results,
        selection_mode=config.selection_mode,
        score_mode=config.score_mode,
        log_offset=5.0,
        top_probability_fraction=0.2,
        dense_odds_variance_threshold=config.dense_odds_variance_threshold,
        cliff_odds_ratio_threshold=config.cliff_odds_ratio_threshold,
        min_ticket_count=config.min_ticket_count,
        max_ticket_count=config.max_ticket_count,
        min_wide_legs=config.min_wide_legs,
        max_wide_legs=config.max_wide_legs,
        min_single_legs=config.min_single_legs,
        max_leg_top_n=config.max_leg_top_n,
        require_wide_legs_on_dense=config.require_wide_legs_on_dense,
    )
    if selected.empty:
        raise ValueError(f"候補がありません: {config.name}")
    return selected.iloc[0]


def summarize_results(name: str, rows: list[dict[str, object]]) -> None:
    work = pd.DataFrame(rows)
    work["race_date"] = pd.to_datetime(work["race_date"], errors="coerce")
    monthly = work.groupby(work["race_date"].dt.to_period("M")).agg(
        day_count=("race_date", "count"),
        total_cost_yen=("cost_yen", "sum"),
        hit_count=("all_hit", "sum"),
        total_return_yen=("return_yen", "sum"),
        total_profit_yen=("profit_yen", "sum"),
    ).reset_index()
    monthly["roi"] = monthly["total_return_yen"] / monthly["total_cost_yen"]

    print(f"STRATEGY {name}")
    print(
        work[
            [
                "race_date",
                "pattern",
                "ticket_count",
                "cost_yen",
                "all_hit",
                "bought_hit",
                "return_yen",
                "profit_yen",
            ]
        ].to_string(index=False)
    )
    print(
        monthly.to_string(
            index=False,
            formatters={
                "total_cost_yen": "{:.0f}".format,
                "total_return_yen": "{:.0f}".format,
                "total_profit_yen": "{:.0f}".format,
                "roi": "{:.4f}".format,
            },
        )
    )
    total_cost = float(work["cost_yen"].sum())
    total_return = float(work["return_yen"].sum())
    print(
        "TOTAL "
        f"day_count={len(work)} "
        f"hit_count={int(work['all_hit'].sum())} "
        f"bought_hit_count={int(work['bought_hit'].sum())} "
        f"total_cost_yen={int(total_cost)} "
        f"total_return_yen={int(total_return)} "
        f"total_profit_yen={int(work['profit_yen'].sum())} "
        f"roi={(total_return / total_cost) if total_cost > 0 else 0.0:.4f} "
        f"hit_rate={float(work['all_hit'].mean()) if len(work) else 0.0:.4f} "
        f"avg_ticket_count={float(work['ticket_count'].mean()) if len(work) else 0.0:.2f}"
    )
    print("---")


def save_report_artifacts(
    results_by_strategy: dict[str, list[dict[str, object]]],
    daily_csv_path: Path,
    monthly_csv_path: Path,
    plot_path: Path,
) -> None:
    daily_frames: list[pd.DataFrame] = []
    monthly_frames: list[pd.DataFrame] = []
    for strategy_name, rows in results_by_strategy.items():
        work = pd.DataFrame(rows).copy()
        if work.empty:
            continue
        work["strategy"] = strategy_name
        work["race_date"] = pd.to_datetime(work["race_date"], errors="coerce")
        work = work.sort_values("race_date").reset_index(drop=True)
        work["cumulative_profit_yen"] = work["profit_yen"].cumsum()
        daily_frames.append(work)

        monthly = work.groupby(work["race_date"].dt.to_period("M")).agg(
            day_count=("race_date", "count"),
            total_cost_yen=("cost_yen", "sum"),
            hit_count=("all_hit", "sum"),
            total_return_yen=("return_yen", "sum"),
            total_profit_yen=("profit_yen", "sum"),
        ).reset_index()
        monthly["strategy"] = strategy_name
        monthly["roi"] = monthly["total_return_yen"] / monthly["total_cost_yen"]
        monthly_frames.append(monthly)

    if not daily_frames or not monthly_frames:
        return

    daily_output = pd.concat(daily_frames, ignore_index=True)
    monthly_output = pd.concat(monthly_frames, ignore_index=True)
    daily_output = daily_output.sort_values(["strategy", "race_date"]).reset_index(drop=True)
    monthly_output = monthly_output.sort_values(["strategy", "race_date"]).reset_index(drop=True)

    daily_csv_path.parent.mkdir(parents=True, exist_ok=True)
    monthly_csv_path.parent.mkdir(parents=True, exist_ok=True)
    plot_path.parent.mkdir(parents=True, exist_ok=True)
    daily_output.to_csv(daily_csv_path, index=False)
    monthly_output.to_csv(monthly_csv_path, index=False)

    fig, axes = plt.subplots(2, 1, figsize=(12, 9), constrained_layout=True)

    for strategy_name, strategy_frame in daily_output.groupby("strategy", sort=False):
        axes[0].plot(
            strategy_frame["race_date"],
            strategy_frame["cumulative_profit_yen"],
            marker="o",
            linewidth=2,
            label=strategy_name,
        )
    axes[0].axhline(0, color="black", linewidth=1, alpha=0.5)
    axes[0].set_title("Cumulative Profit by WIN5 Day")
    axes[0].set_ylabel("Profit (yen)")
    axes[0].legend()

    monthly_pivot = monthly_output.copy()
    monthly_pivot["race_month"] = monthly_pivot["race_date"].astype(str)
    month_labels = list(dict.fromkeys(monthly_pivot["race_month"].tolist()))
    x_positions = list(range(len(month_labels)))
    width = 0.35 if monthly_output["strategy"].nunique() > 1 else 0.6
    offsets = {
        strategy_name: (index - (monthly_output["strategy"].nunique() - 1) / 2.0) * width
        for index, strategy_name in enumerate(monthly_output["strategy"].drop_duplicates().tolist())
    }
    for strategy_name, strategy_frame in monthly_output.groupby("strategy", sort=False):
        value_map = {str(row.race_date): float(row.roi) for row in strategy_frame.itertuples(index=False)}
        axes[1].bar(
            [position + offsets[strategy_name] for position in x_positions],
            [value_map.get(label, 0.0) for label in month_labels],
            width=width,
            label=strategy_name,
        )
    axes[1].set_title("Monthly ROI")
    axes[1].set_ylabel("ROI")
    axes[1].set_xticks(x_positions)
    axes[1].set_xticklabels(month_labels)
    axes[1].legend()

    fig.savefig(plot_path, dpi=150)
    plt.close(fig)


def main() -> None:
    parser = argparse.ArgumentParser(description="月次 WIN5 比較")
    parser.add_argument("--start-date", default="2026-01-01")
    parser.add_argument("--end-date", default="2026-03-15")
    parser.add_argument("--daily-output-csv", default="logs/backtest_monthly_compare_daily.csv")
    parser.add_argument("--monthly-output-csv", default="logs/backtest_monthly_compare_monthly.csv")
    parser.add_argument("--plot-output", default="logs/backtest_monthly_compare.png")
    args = parser.parse_args()

    payouts = load_win5_payouts_from_db(start_date=args.start_date, end_date=args.end_date)
    checkpoints = load_checkpoints("models/algo5_v3_4.pth", "models/algo5_v3_5.pth", "cpu")
    ensemble_weights = parse_ensemble_weights("0.6,0.4", 2)
    checkpoint_config, feature_columns = validate_checkpoint_compatibility(checkpoints)
    dataframe = load_backtest_dataframe(
        database_name="algo_5_db",
        table_name="algo5_training_data",
        race_date_col="race_date",
        min_race_date=checkpoint_config.get("min_race_date", "2024-01-01"),
        feature_columns=feature_columns,
        target_col="target_class",
        num_classes=int(checkpoint_config.get("num_classes", 18)),
        zero_feature_columns=checkpoint_config.get("zero_feature_columns"),
    )
    if "feature_2" in dataframe.columns:
        dataframe["raw_feature_2"] = pd.to_numeric(dataframe["feature_2"], errors="coerce")
    models = build_models(checkpoints=checkpoints, feature_columns=feature_columns)
    standardize_features = bool(checkpoint_config.get("standardize_features", True))

    strategies = [
        StrategyConfig(
            name="rule_based_common",
            selection_mode="rule-based",
            score_mode="expected_return",
            dense_odds_variance_threshold=10.0,
            cliff_odds_ratio_threshold=1.5,
            min_ticket_count=48,
            max_ticket_count=128,
            min_wide_legs=2,
            max_wide_legs=2,
            min_single_legs=1,
            max_leg_top_n=4,
            require_wide_legs_on_dense=True,
        ),
        StrategyConfig(
            name="legacy_expected_return",
            selection_mode="score",
            score_mode="expected_return",
            dense_odds_variance_threshold=None,
            cliff_odds_ratio_threshold=None,
            min_ticket_count=None,
            max_ticket_count=None,
            min_wide_legs=None,
            max_wide_legs=None,
            min_single_legs=None,
            max_leg_top_n=None,
            require_wide_legs_on_dense=False,
        ),
    ]

    results_by_strategy: dict[str, list[dict[str, object]]] = {config.name: [] for config in strategies}
    for payout_row in payouts.itertuples(index=False):
        target_date = pd.Timestamp(payout_row.race_date).date().isoformat()
        payouts_for_date = payouts.loc[payouts["race_date"] == payout_row.race_date].copy()
        daily_results = evaluate_for_date(
            target_date=target_date,
            payouts_for_date=payouts_for_date,
            dataframe=dataframe,
            feature_columns=feature_columns,
            standardize_features=standardize_features,
            models=models,
            ensemble_weights=ensemble_weights,
        )
        for config in strategies:
            selected_row = select_strategy_row(daily_results=daily_results, config=config)
            record = selected_row.to_dict()
            actual_payout = int(payout_row.payout_yen)
            record["actual_payout_yen"] = actual_payout
            record["return_yen"] = int(record["bought_hit"]) * actual_payout
            record["profit_yen"] = int(record["return_yen"]) - int(record["cost_yen"])
            results_by_strategy[config.name].append(record)

    print(
        payouts.assign(race_date=payouts["race_date"].dt.date.astype(str)).to_string(index=False)
    )
    print("===")
    for config in strategies:
        summarize_results(config.name, results_by_strategy[config.name])
    save_report_artifacts(
        results_by_strategy=results_by_strategy,
        daily_csv_path=Path(args.daily_output_csv),
        monthly_csv_path=Path(args.monthly_output_csv),
        plot_path=Path(args.plot_output),
    )


if __name__ == "__main__":
    main()
