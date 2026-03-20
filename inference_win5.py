from __future__ import annotations

import argparse
import itertools
import math
from pathlib import Path

import pandas as pd
import torch
from sqlalchemy import text

from jravan_dataframe_extractor import JravanDataFrameExtractor
from train_win5 import apply_zero_feature_columns, fit_feature_scaler, validate_training_dataframe
from win5_resnet_model import build_win5_resnet_model


CENTRAL_JRA_JYO_CODES = {"05", "06", "07", "08", "09", "10"}


def parse_ensemble_model_paths(raw_text: str | None) -> list[str]:
    if not raw_text:
        return []
    return [value.strip() for value in raw_text.split(",") if value.strip()]


def parse_ensemble_weights(raw_text: str | None, model_count: int) -> list[float]:
    if model_count <= 0:
        raise ValueError("ensemble の model_count が不正です")
    if not raw_text:
        return [1.0 / model_count] * model_count

    raw_values = [value.strip() for value in raw_text.split(",") if value.strip()]
    if len(raw_values) != model_count:
        raise ValueError("--ensemble-weights の数がモデル数と一致していません")

    weights = [float(value) for value in raw_values]
    if any(weight < 0.0 for weight in weights):
        raise ValueError("--ensemble-weights には負の値を指定できません")

    total_weight = sum(weights)
    if total_weight <= 0.0:
        raise ValueError("--ensemble-weights の合計は正である必要があります")
    return [weight / total_weight for weight in weights]


def load_checkpoints(model_path: str, ensemble_model_paths_text: str | None, device: str) -> list[dict[str, object]]:
    model_paths = [model_path] + parse_ensemble_model_paths(ensemble_model_paths_text)
    checkpoints = [torch.load(path, map_location=device) for path in model_paths]
    if not checkpoints:
        raise ValueError("checkpoint が1件も読み込めませんでした")
    return checkpoints


def validate_checkpoint_compatibility(checkpoints: list[dict[str, object]]) -> tuple[dict[str, object], list[str]]:
    reference_checkpoint = checkpoints[0]
    reference_config = reference_checkpoint["config"]
    reference_feature_columns = list(reference_checkpoint["feature_columns"])

    for checkpoint in checkpoints[1:]:
        config = checkpoint["config"]
        feature_columns = list(checkpoint["feature_columns"])
        if feature_columns != reference_feature_columns:
            raise ValueError("アンサンブル対象モデルの feature_columns が一致していません")

        compared_keys = ["input_dim", "num_classes", "standardize_features", "min_race_date", "zero_feature_columns"]
        for key in compared_keys:
            if config.get(key) != reference_config.get(key):
                raise ValueError(f"アンサンブル対象モデルの設定が一致していません: {key}")

    return reference_config, reference_feature_columns


def load_backtest_dataframe(
    database_name: str,
    table_name: str,
    race_date_col: str,
    min_race_date: str,
    feature_columns: list[str],
    target_col: str,
    num_classes: int,
    zero_feature_columns: list[str] | None,
) -> pd.DataFrame:
    extractor = JravanDataFrameExtractor(env_path=".env", database_name=database_name)
    try:
        dataframe = extractor.fetch_table_dataframe(
            table_name=table_name,
            years=5,
            race_date_col=race_date_col,
        )
    finally:
        extractor.close()

    dataframe[race_date_col] = pd.to_datetime(dataframe[race_date_col], errors="coerce")
    dataframe = dataframe.loc[dataframe[race_date_col] >= pd.Timestamp(min_race_date)].copy()
    dataframe = apply_zero_feature_columns(dataframe, zero_feature_columns)
    return validate_training_dataframe(
        dataframe=dataframe,
        feature_columns=feature_columns,
        target_col=target_col,
        num_classes=num_classes,
    )


def apply_scaler_from_history(
    dataframe: pd.DataFrame,
    feature_columns: list[str],
    race_date_col: str,
    backtest_start_date: str,
    standardize_features: bool,
) -> pd.DataFrame:
    if not standardize_features:
        return dataframe

    cutoff = pd.Timestamp(backtest_start_date)
    history_dataframe = dataframe.loc[dataframe[race_date_col] < cutoff].copy()
    if history_dataframe.empty:
        raise ValueError("backtest_start_date より前の学習履歴がないため標準化できません")

    scaler = fit_feature_scaler(history_dataframe, feature_columns)
    return scaler.transform(dataframe, feature_columns)


def score_races(
    dataframe: pd.DataFrame,
    models: list[torch.nn.Module],
    ensemble_weights: list[float],
    feature_columns: list[str],
    race_date_col: str,
    device: torch.device,
) -> pd.DataFrame:
    if not models:
        raise ValueError("score_races にモデルがありません")
    if len(models) != len(ensemble_weights):
        raise ValueError("ensemble_weights の数が models と一致していません")

    for model in models:
        model.eval()
    features = torch.tensor(dataframe[feature_columns].to_numpy(dtype="float32"), dtype=torch.float32, device=device)

    with torch.no_grad():
        probability_sum = None
        for model, weight in zip(models, ensemble_weights):
            model_probabilities = torch.softmax(model(features), dim=1)
            weighted_probabilities = model_probabilities * float(weight)
            probability_sum = weighted_probabilities if probability_sum is None else probability_sum + weighted_probabilities
        probabilities = probability_sum.cpu().numpy()

    scored = dataframe.copy()
    scored["predicted_win_probability"] = probabilities[:, 0]
    scored = scored.sort_values([race_date_col, "race_id", "predicted_win_probability"], ascending=[True, True, False]).copy()
    scored["predicted_rank"] = scored.groupby("race_id")["predicted_win_probability"].rank(method="first", ascending=False)
    return scored


def load_race_schedule_metadata(start_date: pd.Timestamp, end_date: pd.Timestamp) -> pd.DataFrame:
    extractor = JravanDataFrameExtractor(env_path=".env", database_name="jravantest")
    query = text(
        """
        SELECT
            CONCAT(Year, JyoCD, Kaiji, Nichiji, RaceNum) AS race_id,
            STR_TO_DATE(CONCAT(Year, MonthDay), '%Y%m%d') AS race_date,
            JyoCD AS jyo_cd,
            Kaiji AS kaiji,
            Nichiji AS nichiji,
            RaceNum AS race_num,
            HassoTime AS hasso_time,
            GradeCD AS grade_cd,
            TokuNum AS toku_num,
            Hondai AS hondai
        FROM N_RACE
        WHERE STR_TO_DATE(CONCAT(Year, MonthDay), '%Y%m%d') BETWEEN :start_date AND :end_date
        """
    )
    try:
        with extractor._engine.connect() as connection:
            schedule = pd.read_sql_query(
                query,
                connection,
                params={"start_date": start_date.date(), "end_date": end_date.date()},
            )
    finally:
        extractor.close()

    if schedule.empty:
        return schedule

    schedule["race_date"] = pd.to_datetime(schedule["race_date"], errors="coerce")
    schedule["race_num"] = pd.to_numeric(schedule["race_num"], errors="coerce")
    schedule["hasso_time"] = schedule["hasso_time"].astype(str).str.zfill(4)
    schedule["hasso_time_sort"] = pd.to_numeric(schedule["hasso_time"], errors="coerce")
    schedule["is_central_jra"] = schedule["jyo_cd"].isin(CENTRAL_JRA_JYO_CODES)
    schedule["has_valid_hasso_time"] = schedule["hasso_time"].str.fullmatch(r"\d{4}") & (schedule["hasso_time"] != "0000")
    schedule["is_special_race"] = (
        schedule["grade_cd"].fillna("").astype(str).str.strip().ne("")
        | schedule["toku_num"].fillna("").astype(str).str.strip().ne("")
        | schedule["hondai"].fillna("").astype(str).str.strip().ne("")
    )
    return schedule


def summarize_topn_backtest(scored_dataframe: pd.DataFrame, top_n: int) -> dict[str, float]:
    winners = scored_dataframe.loc[scored_dataframe["target_class"] == 0].copy()
    total_races = float(len(winners))
    hit_races = float((winners["predicted_rank"] <= top_n).sum())
    average_winner_probability = float(winners["predicted_win_probability"].mean()) if not winners.empty else 0.0

    return {
        "race_count": total_races,
        "topn": float(top_n),
        "race_hit_rate": hit_races / total_races if total_races else 0.0,
        "average_tickets_per_race": float(top_n),
        "average_winner_probability": average_winner_probability,
    }


def add_race_metadata(scored_dataframe: pd.DataFrame, race_date_col: str) -> pd.DataFrame:
    enriched = scored_dataframe.copy()
    enriched["race_num"] = pd.to_numeric(enriched["race_id"].astype(str).str[-2:], errors="coerce")
    enriched["nichiji"] = enriched["race_id"].astype(str).str[-4:-2]
    enriched["kaiji"] = enriched["race_id"].astype(str).str[-6:-4]
    enriched["jyo_cd"] = enriched["race_id"].astype(str).str[-8:-6]
    enriched = enriched.dropna(subset=["race_num"]).copy()
    enriched["race_num"] = enriched["race_num"].astype(int)
    enriched[race_date_col] = pd.to_datetime(enriched[race_date_col], errors="coerce")
    return enriched


def merge_race_schedule_metadata(
    scored_dataframe: pd.DataFrame,
    schedule_dataframe: pd.DataFrame,
    race_date_col: str,
) -> pd.DataFrame:
    if schedule_dataframe.empty:
        return add_race_metadata(scored_dataframe, race_date_col)

    enriched = add_race_metadata(scored_dataframe, race_date_col)
    schedule = schedule_dataframe.copy()
    schedule = schedule.drop_duplicates(subset=["race_id"])
    merged = enriched.merge(
        schedule[
            [
                "race_id",
                "hasso_time",
                "hasso_time_sort",
                "grade_cd",
                "toku_num",
                "hondai",
                "is_central_jra",
                "has_valid_hasso_time",
                "is_special_race",
            ]
        ],
        on="race_id",
        how="left",
    )
    return merged


def select_main_races_for_day(race_meta: pd.DataFrame) -> pd.DataFrame:
    main_rows: list[pd.Series] = []
    for _, venue_frame in race_meta.groupby("jyo_cd", sort=True):
        venue_sorted = venue_frame.sort_values(["hasso_time_sort", "race_num", "race_id"]).copy()
        if venue_sorted.empty:
            continue

        preferred_11 = venue_sorted.loc[venue_sorted["race_num"] == 11]
        if not preferred_11.empty:
            main_rows.append(preferred_11.iloc[0])
            continue

        preferred_special = venue_sorted.loc[(venue_sorted["race_num"] <= 11) & (venue_sorted["is_special_race"] == True)]
        if not preferred_special.empty:
            main_rows.append(preferred_special.sort_values(["race_num", "hasso_time_sort"], ascending=[False, False]).iloc[0])
            continue

        preferred_before_12 = venue_sorted.loc[venue_sorted["race_num"] <= 11]
        if not preferred_before_12.empty:
            main_rows.append(preferred_before_12.sort_values(["race_num", "hasso_time_sort"], ascending=[False, False]).iloc[0])
            continue

        main_rows.append(venue_sorted.sort_values(["race_num", "hasso_time_sort"], ascending=[False, False]).iloc[0])

    if not main_rows:
        return race_meta.iloc[0:0].copy()
    return pd.DataFrame(main_rows).reset_index(drop=True)


def select_jra_win5_races_for_day(race_meta: pd.DataFrame, required_races: int) -> list[str]:
    central = race_meta.loc[
        (race_meta["is_central_jra"] == True) & (race_meta["has_valid_hasso_time"] == True)
    ].copy()
    if central.empty:
        return []

    main_races = select_main_races_for_day(central)
    if main_races.empty:
        return []

    selected_ids = set(main_races["race_id"].astype(str))
    remaining_candidates: list[dict[str, object]] = []

    for _, main_row in main_races.iterrows():
        venue_frame = central.loc[central["jyo_cd"] == main_row["jyo_cd"]].sort_values(["hasso_time_sort", "race_num", "race_id"]).reset_index(drop=True)
        main_index = venue_frame.index[venue_frame["race_id"] == main_row["race_id"]]
        if len(main_index) == 0:
            continue
        anchor = int(main_index[0])
        for row_index, row in venue_frame.iterrows():
            race_id = str(row["race_id"])
            if race_id in selected_ids:
                continue
            distance = abs(int(row["hasso_time_sort"]) - int(main_row["hasso_time_sort"]))
            direction_priority = 0 if row_index < anchor else 1
            race_num_gap = abs(int(row["race_num"]) - int(main_row["race_num"]))
            remaining_candidates.append(
                {
                    "race_id": race_id,
                    "distance": distance,
                    "direction_priority": direction_priority,
                    "race_num_gap": race_num_gap,
                    "hasso_time_sort": int(row["hasso_time_sort"]),
                }
            )

    remaining_candidates = sorted(
        remaining_candidates,
        key=lambda item: (
            item["distance"],
            item["direction_priority"],
            item["race_num_gap"],
            item["hasso_time_sort"],
            item["race_id"],
        ),
    )

    ordered_selected_ids = main_races.sort_values(["hasso_time_sort", "race_num", "race_id"])["race_id"].astype(str).tolist()
    for candidate in remaining_candidates:
        if len(ordered_selected_ids) >= required_races:
            break
        if candidate["race_id"] in selected_ids:
            continue
        ordered_selected_ids.append(candidate["race_id"])
        selected_ids.add(candidate["race_id"])

    if len(ordered_selected_ids) < required_races:
        return []

    final_selection = central.loc[central["race_id"].astype(str).isin(ordered_selected_ids)].copy()
    final_selection = final_selection.sort_values(["hasso_time_sort", "race_num", "race_id"])
    return final_selection["race_id"].astype(str).head(required_races).tolist()


def select_win5_races_for_day(
    race_meta: pd.DataFrame,
    selection_mode: str,
    min_race_num: int,
    required_races: int,
) -> list[str]:
    if race_meta.empty:
        return []

    sorting_columns = ["race_num", "jyo_cd", "kaiji", "nichiji", "race_id"]
    descending = race_meta.sort_values(sorting_columns, ascending=[False, False, False, False, False]).copy()

    if selection_mode == "jra_win5_rule":
        return select_jra_win5_races_for_day(race_meta=race_meta, required_races=required_races)
    if selection_mode == "late5":
        late_races = descending.loc[descending["race_num"] >= min_race_num].copy()
        if len(late_races) >= required_races:
            selected = late_races.head(required_races).copy()
        else:
            selected = descending.head(required_races).copy()
    elif selection_mode == "last5":
        selected = descending.head(required_races).copy()
    else:
        raise ValueError(f"未対応の selection_mode です: {selection_mode}")

    selected = selected.sort_values(sorting_columns).copy()
    return selected["race_id"].tolist()


def build_daily_win5_groups(
    scored_dataframe: pd.DataFrame,
    race_date_col: str,
    selection_mode: str,
    min_race_num: int,
    required_races: int,
) -> list[dict[str, object]]:
    metadata_columns = [race_date_col, "race_id", "race_num", "jyo_cd", "kaiji", "nichiji"]
    optional_columns = [
        "hasso_time",
        "hasso_time_sort",
        "grade_cd",
        "toku_num",
        "hondai",
        "is_central_jra",
        "has_valid_hasso_time",
        "is_special_race",
    ]
    available_columns = metadata_columns + [column for column in optional_columns if column in scored_dataframe.columns]
    race_meta = (
        scored_dataframe[available_columns]
        .drop_duplicates(subset=[race_date_col, "race_id"])
        .copy()
    )

    groups: list[dict[str, object]] = []
    for race_date, day_meta in race_meta.groupby(race_date_col, sort=True):
        selected_race_ids = select_win5_races_for_day(
            race_meta=day_meta,
            selection_mode=selection_mode,
            min_race_num=min_race_num,
            required_races=required_races,
        )
        if len(selected_race_ids) != required_races:
            continue
        groups.append({"race_date": race_date, "race_ids": selected_race_ids})
    return groups


def parse_topn_pattern(pattern_text: str, required_races: int) -> tuple[int, ...]:
    values = tuple(int(value.strip()) for value in pattern_text.split(",") if value.strip())
    if len(values) != required_races:
        raise ValueError(f"top-N パターンは {required_races} 個必要です: {pattern_text}")
    if any(value <= 0 for value in values):
        raise ValueError(f"top-N パターンは正の整数で指定してください: {pattern_text}")
    return values


def build_topn_patterns(
    top_n: int,
    top_n_patterns_arg: str | None,
    grid_topn_values_arg: str | None,
    required_races: int,
) -> list[tuple[int, ...]]:
    if top_n_patterns_arg:
        return [
            parse_topn_pattern(pattern_text, required_races)
            for pattern_text in top_n_patterns_arg.split(";")
            if pattern_text.strip()
        ]

    if grid_topn_values_arg:
        grid_values = [int(value.strip()) for value in grid_topn_values_arg.split(",") if value.strip()]
        if not grid_values:
            raise ValueError("grid_topn_values に有効な値がありません")
        if any(value <= 0 for value in grid_values):
            raise ValueError("grid_topn_values には正の整数を指定してください")
        return list(dict.fromkeys(itertools.product(grid_values, repeat=required_races)))

    return [tuple([top_n] * required_races)]


def parse_probability_thresholds(raw_text: str) -> list[float]:
    values = [float(value.strip()) for value in raw_text.split(",") if value.strip()]
    if not values:
        raise ValueError("probability threshold に有効な値がありません")
    if any(value < 0.0 for value in values):
        raise ValueError("probability threshold は 0 以上で指定してください")
    return values


def build_probability_threshold_grid(
    probability_threshold: float,
    probability_thresholds_arg: str | None,
    grid_probability_thresholds_arg: str | None,
) -> list[float]:
    if probability_thresholds_arg:
        return parse_probability_thresholds(probability_thresholds_arg)
    if grid_probability_thresholds_arg:
        return parse_probability_thresholds(grid_probability_thresholds_arg)
    if probability_threshold < 0.0:
        raise ValueError("probability_threshold は 0 以上で指定してください")
    return [probability_threshold]


def parse_expected_value_thresholds(raw_text: str) -> list[float]:
    values = [float(value.strip()) for value in raw_text.split(",") if value.strip()]
    if not values:
        raise ValueError("expected value threshold に有効な値がありません")
    if any(value < 0.0 for value in values):
        raise ValueError("expected value threshold は 0 以上で指定してください")
    return values


def build_expected_value_threshold_grid(
    min_expected_value: float,
    min_expected_values_arg: str | None,
    grid_min_expected_values_arg: str | None,
) -> list[float]:
    if min_expected_values_arg:
        return parse_expected_value_thresholds(min_expected_values_arg)
    if grid_min_expected_values_arg:
        return parse_expected_value_thresholds(grid_min_expected_values_arg)
    if min_expected_value < 0.0:
        raise ValueError("min_expected_value は 0 以上で指定してください")
    return [min_expected_value]


def load_win5_payouts(
    csv_path: str | None,
    payout_date_column: str,
    payout_amount_column: str,
) -> pd.DataFrame:
    if not csv_path:
        return pd.DataFrame(columns=["race_date", "payout_yen"])

    dataframe = pd.read_csv(csv_path)
    missing_columns = {payout_date_column, payout_amount_column}.difference(dataframe.columns)
    if missing_columns:
        missing = ", ".join(sorted(missing_columns))
        raise KeyError(f"払戻CSVに必要な列がありません: {missing}")

    payouts = dataframe[[payout_date_column, payout_amount_column]].copy()
    payouts = payouts.rename(columns={payout_date_column: "race_date", payout_amount_column: "payout_yen"})
    payouts["race_date"] = pd.to_datetime(payouts["race_date"], errors="coerce")
    payouts["payout_yen"] = (
        payouts["payout_yen"]
        .astype(str)
        .str.replace(",", "", regex=False)
        .str.replace("円", "", regex=False)
        .str.strip()
    )
    payouts["payout_yen"] = pd.to_numeric(payouts["payout_yen"], errors="coerce")
    payouts = payouts.dropna(subset=["race_date", "payout_yen"]).copy()
    payouts["race_date"] = payouts["race_date"].dt.normalize()
    payouts = payouts.groupby("race_date", as_index=False)["payout_yen"].max()
    return payouts


def apply_payouts_and_expected_value_filter(
    daily_dataframe: pd.DataFrame,
    payout_dataframe: pd.DataFrame,
    min_expected_value: float,
    buy_expected_value_source: str,
    max_probability_sum: float | None,
) -> pd.DataFrame:
    enriched = daily_dataframe.copy()
    enriched["race_date"] = pd.to_datetime(enriched["race_date"], errors="coerce").dt.normalize()

    if payout_dataframe.empty:
        enriched["payout_yen"] = 0.0
    else:
        payouts = payout_dataframe.copy()
        payouts["race_date"] = pd.to_datetime(payouts["race_date"], errors="coerce").dt.normalize()
        enriched = enriched.merge(payouts, on="race_date", how="left")
        enriched["payout_yen"] = enriched["payout_yen"].fillna(0.0)

    if buy_expected_value_source == "actual":
        buy_expected_payout = enriched["payout_yen"]
    elif buy_expected_value_source == "estimated":
        buy_expected_payout = enriched["estimated_payout_yen"]
    elif buy_expected_value_source == "auto":
        buy_expected_payout = enriched["payout_yen"].where(enriched["payout_yen"] > 0.0, enriched["estimated_payout_yen"])
    else:
        raise ValueError(f"未対応の buy_expected_value_source です: {buy_expected_value_source}")

    enriched["buy_expected_value_source"] = buy_expected_value_source
    enriched["buy_expected_payout_yen"] = buy_expected_payout.fillna(0.0)
    enriched["expected_return_yen"] = enriched["selected_probability_sum"] * enriched["buy_expected_payout_yen"]
    enriched["expected_value_ratio"] = 0.0
    positive_cost = enriched["cost_yen"] > 0
    enriched.loc[positive_cost, "expected_value_ratio"] = (
        enriched.loc[positive_cost, "expected_return_yen"] / enriched.loc[positive_cost, "cost_yen"]
    )
    enriched["min_expected_value"] = float(min_expected_value)
    probability_limit = None if max_probability_sum is None or max_probability_sum <= 0.0 else float(max_probability_sum)
    enriched["max_probability_sum"] = probability_limit if probability_limit is not None else float("nan")
    enriched["low_payout_alert"] = 0
    if probability_limit is not None:
        enriched["low_payout_alert"] = (enriched["selected_probability_sum"] > probability_limit).astype(int)

    base_buy_flag = (
        (enriched["cost_yen"] > 0)
        & (enriched["expected_value_ratio"] >= float(min_expected_value))
    )
    if probability_limit is not None:
        base_buy_flag = base_buy_flag & (enriched["selected_probability_sum"] <= probability_limit)
    enriched["buy_flag"] = base_buy_flag.astype(int)
    enriched["return_yen"] = enriched["buy_flag"] * enriched["all_hit"] * enriched["payout_yen"]
    enriched["estimated_return_yen"] = enriched["buy_flag"] * enriched["all_hit"] * enriched["estimated_payout_yen"]
    enriched["actual_cost_yen"] = enriched["buy_flag"] * enriched["cost_yen"]
    enriched["profit_yen"] = enriched["return_yen"] - enriched["actual_cost_yen"]
    enriched["estimated_profit_yen"] = enriched["estimated_return_yen"] - enriched["actual_cost_yen"]
    enriched["bought_hit"] = (enriched["buy_flag"] * enriched["all_hit"]).astype(int)
    enriched["race_date"] = enriched["race_date"].dt.date.astype(str)
    return enriched


def summarize_strategy_performance(
    daily_dataframe: pd.DataFrame,
    pattern: str,
    probability_threshold: float,
    min_expected_value: float,
) -> dict[str, float | str]:
    total_days = len(daily_dataframe)
    purchase_day_count = int(daily_dataframe["buy_flag"].sum()) if not daily_dataframe.empty else 0
    hit_count = int(daily_dataframe["all_hit"].sum()) if not daily_dataframe.empty else 0
    bought_hit_count = int(daily_dataframe["bought_hit"].sum()) if not daily_dataframe.empty else 0
    total_cost_yen = float(daily_dataframe["actual_cost_yen"].sum()) if not daily_dataframe.empty else 0.0
    total_return_yen = float(daily_dataframe["return_yen"].sum()) if not daily_dataframe.empty else 0.0
    estimated_total_return_yen = float(daily_dataframe["estimated_return_yen"].sum()) if not daily_dataframe.empty else 0.0
    total_profit_yen = total_return_yen - total_cost_yen
    estimated_total_profit_yen = estimated_total_return_yen - total_cost_yen
    average_expected_value_ratio = (
        float(daily_dataframe.loc[daily_dataframe["buy_flag"] == 1, "expected_value_ratio"].mean())
        if purchase_day_count
        else 0.0
    )
    correlation_frame = daily_dataframe.loc[
        (daily_dataframe["payout_yen"] > 0) & (daily_dataframe["estimated_payout_yen"] > 0),
        ["payout_yen", "estimated_payout_yen"],
    ].copy()
    payout_correlation = (
        float(correlation_frame["payout_yen"].corr(correlation_frame["estimated_payout_yen"]))
        if len(correlation_frame) >= 2
        else 0.0
    )
    low_payout_alert_days = int(daily_dataframe["low_payout_alert"].sum()) if "low_payout_alert" in daily_dataframe.columns else 0
    max_probability_sum = (
        float(daily_dataframe["max_probability_sum"].dropna().iloc[0])
        if "max_probability_sum" in daily_dataframe.columns and daily_dataframe["max_probability_sum"].notna().any()
        else 0.0
    )
    max_bet_amount = (
        float(daily_dataframe["max_bet_amount"].iloc[0])
        if "max_bet_amount" in daily_dataframe.columns and not daily_dataframe.empty
        else 0.0
    )
    average_raw_ticket_count = (
        float(daily_dataframe.loc[daily_dataframe["buy_flag"] == 1, "raw_ticket_count"].mean())
        if purchase_day_count and "raw_ticket_count" in daily_dataframe.columns
        else 0.0
    )

    return {
        "pattern": pattern,
        "probability_threshold": float(probability_threshold),
        "min_expected_value": float(min_expected_value),
        "max_probability_sum": max_probability_sum,
        "max_bet_amount": max_bet_amount,
        "buy_expected_value_source": str(daily_dataframe["buy_expected_value_source"].iloc[0]) if not daily_dataframe.empty else "actual",
        "day_count": float(total_days),
        "purchase_day_count": float(purchase_day_count),
        "purchase_rate": purchase_day_count / total_days if total_days else 0.0,
        "win5_hit_count": float(hit_count),
        "bought_hit_count": float(bought_hit_count),
        "low_payout_alert_days": float(low_payout_alert_days),
        "win5_hit_rate": hit_count / total_days if total_days else 0.0,
        "bought_hit_rate": bought_hit_count / purchase_day_count if purchase_day_count else 0.0,
        "average_ticket_count": float(daily_dataframe.loc[daily_dataframe["buy_flag"] == 1, "ticket_count"].mean()) if purchase_day_count else 0.0,
        "average_raw_ticket_count": average_raw_ticket_count,
        "average_cost_yen": float(daily_dataframe.loc[daily_dataframe["buy_flag"] == 1, "actual_cost_yen"].mean()) if purchase_day_count else 0.0,
        "average_selected_probability_sum": float(daily_dataframe.loc[daily_dataframe["buy_flag"] == 1, "selected_probability_sum"].mean()) if purchase_day_count else 0.0,
        "average_expected_value_ratio": average_expected_value_ratio,
        "total_cost_yen": total_cost_yen,
        "total_return_yen": total_return_yen,
        "total_profit_yen": total_profit_yen,
        "estimated_total_return_yen": estimated_total_return_yen,
        "estimated_total_profit_yen": estimated_total_profit_yen,
        "roi": (total_return_yen / total_cost_yen) if total_cost_yen > 0 else 0.0,
        "estimated_roi": (estimated_total_return_yen / total_cost_yen) if total_cost_yen > 0 else 0.0,
        "payout_correlation": payout_correlation if math.isfinite(payout_correlation) else 0.0,
    }


def build_race_result_lookup(scored_dataframe: pd.DataFrame) -> dict[str, dict[str, object]]:
    lookup: dict[str, dict[str, object]] = {}
    for race_id, race_frame in scored_dataframe.groupby("race_id", sort=False):
        sorted_frame = race_frame.sort_values("predicted_rank").copy()
        winners = sorted_frame.loc[sorted_frame["target_class"] == 0].copy()
        if winners.empty:
            continue

        if "raw_feature_2" in sorted_frame.columns:
            market_win_odds = pd.to_numeric(sorted_frame["raw_feature_2"], errors="coerce") * 100.0
            market_win_odds = market_win_odds.where(market_win_odds > 0.0)
        elif "feature_2" in sorted_frame.columns:
            market_win_odds = pd.to_numeric(sorted_frame["feature_2"], errors="coerce") * 100.0
            market_win_odds = market_win_odds.where(market_win_odds > 0.0)
        else:
            market_win_odds = pd.Series(index=sorted_frame.index, dtype="float64")

        if market_win_odds.notna().any():
            implied_probabilities = 1.0 / market_win_odds.clip(lower=1.01)
            total_implied_probability = implied_probabilities.sum()
            market_support = implied_probabilities / total_implied_probability if total_implied_probability > 0 else pd.Series(0.0, index=sorted_frame.index)
            favorites = sorted_frame.assign(
                market_win_odds=market_win_odds,
                market_support=market_support,
            ).sort_values(["market_win_odds", "predicted_rank"], ascending=[True, True])
            favorite_odds = float(favorites["market_win_odds"].iloc[0])
            favorite_support = float(favorites["market_support"].iloc[0])
            top3_market_support = float(favorites["market_support"].head(3).sum())
        else:
            market_support = pd.Series(0.0, index=sorted_frame.index)
            favorite_odds = float("nan")
            favorite_support = 0.0
            top3_market_support = 0.0

        winner = winners.iloc[0]
        lookup[str(race_id)] = {
            "winner_rank": int(winner["predicted_rank"]),
            "winner_uma_ban": str(winner["uma_ban"]),
            "winner_probability": float(winner["predicted_win_probability"]),
            "top_horses": sorted_frame.assign(
                market_win_odds=market_win_odds,
                market_support=market_support,
            )[["uma_ban", "predicted_win_probability", "predicted_rank", "market_win_odds", "market_support"]].copy(),
            "race_num": int(sorted_frame["race_num"].iloc[0]),
            "jyo_cd": str(sorted_frame["jyo_cd"].iloc[0]),
            "hasso_time": str(sorted_frame.get("hasso_time", pd.Series([""])).iloc[0]),
            "favorite_odds": favorite_odds,
            "favorite_support": favorite_support,
            "top3_market_support": top3_market_support,
        }
    return lookup


def apply_favorite_side_payout_brake(
    estimated_payout_yen: float,
    race_results: list[dict[str, object]],
    favorite_odds_threshold: float = 3.0,
    favorite_count_decay: float = 0.65,
) -> float:
    if not race_results or estimated_payout_yen <= 0.0:
        return float(max(estimated_payout_yen, 0.0))

    favorite_side_count = 0
    support_penalty = 1.0
    for race_result in race_results:
        favorite_odds = float(race_result.get("favorite_odds", float("nan")))
        favorite_support = float(race_result.get("favorite_support", 0.0))
        if math.isfinite(favorite_odds) and favorite_odds < favorite_odds_threshold:
            favorite_side_count += 1
            support_penalty *= max(0.25, 1.0 - min(max(favorite_support, 0.0), 0.8) * 0.6)

    if favorite_side_count == 0:
        return float(estimated_payout_yen)

    count_penalty = math.exp(-favorite_count_decay * favorite_side_count)
    corrected_payout = estimated_payout_yen * count_penalty * support_penalty
    return float(max(corrected_payout, 100.0))


def estimate_win5_payout_yen(race_results: list[dict[str, object]]) -> float:
    if not race_results:
        return 0.0

    estimated_payout_yen = 100.0
    for race_result in race_results:
        favorite_odds = float(race_result.get("favorite_odds", float("nan")))
        top3_market_support = float(race_result.get("top3_market_support", 0.0))
        if not math.isfinite(favorite_odds) or favorite_odds <= 0.0:
            favorite_odds = 3.0
        support = min(max(top3_market_support, 0.20), 0.95)
        leg_multiplier = min(max(favorite_odds, 1.2), 20.0) * (1.0 / support)
        estimated_payout_yen *= leg_multiplier

    return apply_favorite_side_payout_brake(estimated_payout_yen=estimated_payout_yen, race_results=race_results)


def resolve_dynamic_topn(
    race_result: dict[str, object],
    base_top_n: int,
    dynamic_topn_enabled: bool,
    dynamic_topn_threshold: float,
    dynamic_topn_max: int,
) -> tuple[int, float]:
    if not dynamic_topn_enabled:
        return base_top_n, 0.0

    top_horses = race_result["top_horses"]
    if len(top_horses) < base_top_n:
        return min(base_top_n, len(top_horses)), 0.0

    rank1_probability = float(top_horses.iloc[0]["predicted_win_probability"])
    rankn_probability = float(top_horses.iloc[base_top_n - 1]["predicted_win_probability"])
    probability_gap = rank1_probability - rankn_probability
    if probability_gap <= dynamic_topn_threshold:
        expanded_top_n = min(dynamic_topn_max, len(top_horses))
        return expanded_top_n, probability_gap
    return base_top_n, probability_gap


def build_candidate_legs(
    race_results: list[dict[str, object]],
    topn_pattern: tuple[int, ...],
 ) -> tuple[list[list[tuple[str, float]]], tuple[str, ...]]:
    candidate_legs: list[list[tuple[str, float]]] = []
    winner_combination: list[str] = []
    for race_result, top_n in zip(race_results, topn_pattern):
        top_horses = race_result["top_horses"].head(top_n)
        leg_candidates = [
            (str(row.uma_ban), float(row.predicted_win_probability))
            for row in top_horses.itertuples(index=False)
        ]
        if not leg_candidates:
            return [], tuple()
        candidate_legs.append(leg_candidates)
        winner_combination.append(str(race_result["winner_uma_ban"]))

    return candidate_legs, tuple(winner_combination)


def compute_selected_combinations(
    race_results: list[dict[str, object]],
    topn_pattern: tuple[int, ...],
    probability_threshold: float,
    max_ticket_count: int | None,
) -> dict[str, object]:
    candidate_legs, winner_combination = build_candidate_legs(race_results=race_results, topn_pattern=topn_pattern)
    if not candidate_legs:
        return {
            "ticket_count": 0,
            "raw_ticket_count": 0,
            "selected_probability_sum": 0.0,
            "winner_combo_selected": False,
            "budget_capped": False,
            "budget_ticket_limit": int(max_ticket_count) if max_ticket_count is not None else 0,
        }

    combinations: list[tuple[tuple[str, ...], float]] = []
    for combination in itertools.product(*candidate_legs):
        horses = tuple(str(uma_ban) for uma_ban, _ in combination)
        joint_probability = 1.0
        for _, probability in combination:
            joint_probability *= probability
        if joint_probability >= probability_threshold:
            combinations.append((horses, joint_probability))

    raw_ticket_count = len(combinations)
    if raw_ticket_count == 0:
        return {
            "ticket_count": 0,
            "raw_ticket_count": 0,
            "selected_probability_sum": 0.0,
            "winner_combo_selected": False,
            "budget_capped": False,
            "budget_ticket_limit": int(max_ticket_count) if max_ticket_count is not None else 0,
        }

    combinations.sort(key=lambda item: (-item[1], item[0]))
    budget_capped = False
    if max_ticket_count is not None:
        allowed_ticket_count = max(int(max_ticket_count), 0)
        budget_capped = raw_ticket_count > allowed_ticket_count
        combinations = combinations[:allowed_ticket_count]

    selected_probability_sum = float(sum(probability for _, probability in combinations))
    selected_combinations = {horses for horses, _ in combinations}
    return {
        "ticket_count": len(combinations),
        "raw_ticket_count": raw_ticket_count,
        "selected_probability_sum": selected_probability_sum,
        "winner_combo_selected": winner_combination in selected_combinations,
        "budget_capped": budget_capped,
        "budget_ticket_limit": int(max_ticket_count) if max_ticket_count is not None else 0,
    }


def summarize_win5_pattern(
    daily_groups: list[dict[str, object]],
    race_lookup: dict[str, dict[str, object]],
    topn_pattern: tuple[int, ...],
    ticket_unit: int,
    probability_threshold: float,
    max_bet_amount: int | None,
    dynamic_topn_enabled: bool,
    dynamic_topn_threshold: float,
    dynamic_topn_max: int,
) -> tuple[dict[str, float | str], pd.DataFrame]:
    daily_records: list[dict[str, object]] = []
    leg_hits = 0
    total_legs = 0
    all_hit_days = 0
    total_cost = 0
    total_selected_probability_sum = 0.0
    max_ticket_count = None
    if max_bet_amount is not None:
        max_ticket_count = max(int(max_bet_amount) // int(ticket_unit), 0)

    for group in daily_groups:
        race_date = group["race_date"]
        race_ids = group["race_ids"]
        if not isinstance(race_ids, list):
            continue
        if any(str(race_id) not in race_lookup for race_id in race_ids):
            continue

        day_hit = True
        day_leg_hit = True
        day_record: dict[str, object] = {
            "race_date": pd.Timestamp(race_date).date().isoformat(),
            "ticket_count": 1,
        }
        race_results_for_day: list[dict[str, object]] = []
        effective_topn_pattern: list[int] = []
        winner_combo_probability = 1.0

        for leg_index, (race_id, top_n) in enumerate(zip(race_ids, topn_pattern), start=1):
            race_result = race_lookup.get(str(race_id))
            if race_result is None:
                day_hit = False
                break

            race_results_for_day.append(race_result)
            effective_top_n, probability_gap = resolve_dynamic_topn(
                race_result=race_result,
                base_top_n=top_n,
                dynamic_topn_enabled=dynamic_topn_enabled,
                dynamic_topn_threshold=dynamic_topn_threshold,
                dynamic_topn_max=dynamic_topn_max,
            )
            effective_topn_pattern.append(effective_top_n)

            hit = int(race_result["winner_rank"] <= effective_top_n)
            leg_hits += hit
            total_legs += 1
            day_leg_hit = day_leg_hit and bool(hit)
            winner_combo_probability *= race_result["winner_probability"]

            top_horses = race_result["top_horses"].head(effective_top_n)
            picked_horses = ",".join(top_horses["uma_ban"].astype(str).tolist())
            day_record[f"leg{leg_index}_race_id"] = race_id
            day_record[f"leg{leg_index}_race_num"] = int(race_result["race_num"])
            day_record[f"leg{leg_index}_hasso_time"] = str(race_result["hasso_time"])
            day_record[f"leg{leg_index}_base_top_n"] = int(top_n)
            day_record[f"leg{leg_index}_top_n"] = int(effective_top_n)
            day_record[f"leg{leg_index}_dynamic_expanded"] = int(effective_top_n > top_n)
            day_record[f"leg{leg_index}_probability_gap"] = float(probability_gap)
            day_record[f"leg{leg_index}_picked"] = picked_horses
            day_record[f"leg{leg_index}_winner"] = str(race_result["winner_uma_ban"])
            day_record[f"leg{leg_index}_winner_rank"] = int(race_result["winner_rank"])
            day_record[f"leg{leg_index}_hit"] = hit

        combination_result = compute_selected_combinations(
            race_results=race_results_for_day,
            topn_pattern=tuple(effective_topn_pattern),
            probability_threshold=probability_threshold,
            max_ticket_count=max_ticket_count,
        )
        ticket_count = int(combination_result["ticket_count"])
        raw_ticket_count = int(combination_result["raw_ticket_count"])
        selected_probability_sum = float(combination_result["selected_probability_sum"])
        estimated_payout_yen = estimate_win5_payout_yen(race_results_for_day)
        combo_selected = bool(combination_result["winner_combo_selected"])
        day_hit = day_hit and day_leg_hit and combo_selected

        day_record["winner_combo_probability"] = float(winner_combo_probability)
        day_record["selected_probability_sum"] = float(selected_probability_sum)
        day_record["estimated_payout_yen"] = float(estimated_payout_yen)
        day_record["probability_threshold"] = float(probability_threshold)
        day_record["max_bet_amount"] = int(max_bet_amount) if max_bet_amount is not None else 0
        day_record["budget_ticket_limit"] = int(combination_result["budget_ticket_limit"])
        day_record["raw_ticket_count"] = raw_ticket_count
        day_record["budget_capped"] = int(bool(combination_result["budget_capped"]))
        day_record["winner_combo_selected"] = int(combo_selected)
        day_record["dynamic_topn_enabled"] = int(dynamic_topn_enabled)
        day_record["ticket_count"] = int(ticket_count)
        day_record["cost_yen"] = int(ticket_count * ticket_unit)
        day_record["all_hit"] = int(day_hit)
        total_cost += int(day_record["cost_yen"])
        total_selected_probability_sum += selected_probability_sum
        all_hit_days += int(day_hit)
        daily_records.append(day_record)

    daily_dataframe = pd.DataFrame(daily_records)
    total_days = len(daily_records)
    summary = {
        "pattern": "-".join(str(value) for value in topn_pattern),
        "probability_threshold": float(probability_threshold),
        "max_bet_amount": float(max_bet_amount) if max_bet_amount is not None else 0.0,
        "day_count": float(total_days),
        "win5_hit_count": float(all_hit_days),
        "win5_hit_rate": all_hit_days / total_days if total_days else 0.0,
        "leg_hit_rate": leg_hits / total_legs if total_legs else 0.0,
        "average_ticket_count": float(daily_dataframe["ticket_count"].mean()) if not daily_dataframe.empty else 0.0,
        "average_raw_ticket_count": float(daily_dataframe["raw_ticket_count"].mean()) if not daily_dataframe.empty else 0.0,
        "average_cost_yen": float(daily_dataframe["cost_yen"].mean()) if not daily_dataframe.empty else 0.0,
        "average_selected_probability_sum": total_selected_probability_sum / total_days if total_days else 0.0,
        "total_cost_yen": float(total_cost),
    }
    return summary, daily_dataframe


def evaluate_win5_patterns(
    scored_dataframe: pd.DataFrame,
    race_date_col: str,
    selection_mode: str,
    min_race_num: int,
    required_races: int,
    topn_patterns: list[tuple[int, ...]],
    ticket_unit: int,
    probability_thresholds: list[float],
    schedule_dataframe: pd.DataFrame,
    payout_dataframe: pd.DataFrame,
    min_expected_values: list[float],
    buy_expected_value_source: str,
    max_probability_sum: float | None,
    max_bet_amount: int | None,
    dynamic_topn_enabled: bool,
    dynamic_topn_threshold: float,
    dynamic_topn_max: int,
) -> tuple[pd.DataFrame, dict[str, pd.DataFrame], int]:
    enriched = merge_race_schedule_metadata(scored_dataframe, schedule_dataframe, race_date_col)
    race_lookup = build_race_result_lookup(enriched)
    valid_race_ids = set(race_lookup.keys())
    daily_groups = build_daily_win5_groups(
        scored_dataframe=enriched.loc[enriched["race_id"].isin(valid_race_ids)].copy(),
        race_date_col=race_date_col,
        selection_mode=selection_mode,
        min_race_num=min_race_num,
        required_races=required_races,
    )

    summaries: list[dict[str, float | str]] = []
    daily_results: dict[str, pd.DataFrame] = {}
    for pattern in topn_patterns:
        for probability_threshold in probability_thresholds:
            base_summary, daily_dataframe = summarize_win5_pattern(
                daily_groups=daily_groups,
                race_lookup=race_lookup,
                topn_pattern=pattern,
                ticket_unit=ticket_unit,
                probability_threshold=probability_threshold,
                max_bet_amount=max_bet_amount,
                dynamic_topn_enabled=dynamic_topn_enabled,
                dynamic_topn_threshold=dynamic_topn_threshold,
                dynamic_topn_max=dynamic_topn_max,
            )
            pattern_label = str(base_summary["pattern"])
            for min_expected_value in min_expected_values:
                enriched_daily = apply_payouts_and_expected_value_filter(
                    daily_dataframe=daily_dataframe,
                    payout_dataframe=payout_dataframe,
                    min_expected_value=min_expected_value,
                    buy_expected_value_source=buy_expected_value_source,
                    max_probability_sum=max_probability_sum,
                )
                summary = summarize_strategy_performance(
                    daily_dataframe=enriched_daily,
                    pattern=pattern_label,
                    probability_threshold=probability_threshold,
                    min_expected_value=min_expected_value,
                )
                pattern_key = (
                    f"{summary['pattern']}|{float(summary['probability_threshold']):.6f}|"
                    f"{float(summary['min_expected_value']):.6f}"
                )
                summaries.append(summary)
                daily_results[pattern_key] = enriched_daily

    summary_dataframe = pd.DataFrame(summaries)
    if not summary_dataframe.empty:
        summary_dataframe = summary_dataframe.sort_values(
            ["roi", "estimated_roi", "total_profit_yen", "estimated_total_profit_yen", "bought_hit_rate", "average_cost_yen"],
            ascending=[False, False, False, False, False, True],
        ).reset_index(drop=True)
    return summary_dataframe, daily_results, len(daily_groups)


def build_auto_selected_daily_patterns(
    daily_results: dict[str, pd.DataFrame],
) -> pd.DataFrame:
    daily_frames: list[pd.DataFrame] = []
    for result_key, daily_dataframe in daily_results.items():
        if daily_dataframe.empty:
            continue

        pattern, probability_threshold_text, min_expected_value_text = result_key.rsplit("|", 2)
        enriched_daily = daily_dataframe.copy()
        enriched_daily["pattern"] = pattern
        enriched_daily["probability_threshold"] = float(probability_threshold_text)
        enriched_daily["min_expected_value"] = float(min_expected_value_text)
        enriched_daily["auto_select_score"] = enriched_daily["expected_return_yen"]
        daily_frames.append(enriched_daily)

    if not daily_frames:
        return pd.DataFrame()

    combined = pd.concat(daily_frames, ignore_index=True)
    combined["race_date"] = pd.to_datetime(combined["race_date"], errors="coerce")

    selected_rows: list[pd.DataFrame] = []
    for _, day_frame in combined.groupby("race_date", sort=True):
        eligible = day_frame.loc[day_frame["buy_flag"] == 1].copy()
        if eligible.empty:
            eligible = day_frame.copy()
        eligible = eligible.sort_values(
            [
                "auto_select_score",
                "buy_flag",
                "expected_value_ratio",
                "selected_probability_sum",
                "cost_yen",
            ],
            ascending=[False, False, False, False, True],
        )
        selected_rows.append(eligible.head(1))

    auto_selected = pd.concat(selected_rows, ignore_index=True)
    auto_selected["race_date"] = auto_selected["race_date"].dt.date.astype(str)
    auto_selected = auto_selected.sort_values("race_date").reset_index(drop=True)
    return auto_selected


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="WIN5 モデルの簡易バックテスト用推論スクリプト")
    parser.add_argument("--model-path", default="models/algo5_final_v2.pth")
    parser.add_argument("--ensemble-model-paths", default=None)
    parser.add_argument("--ensemble-weights", default=None)
    parser.add_argument("--database-name", default="algo_5_db")
    parser.add_argument("--table-name", default="algo5_training_data")
    parser.add_argument("--race-date-col", default="race_date")
    parser.add_argument("--target-col", default="target_class")
    parser.add_argument("--backtest-start-date", required=True)
    parser.add_argument("--backtest-end-date", default=None)
    parser.add_argument("--top-n", type=int, default=3)
    parser.add_argument("--top-n-patterns", default=None)
    parser.add_argument("--grid-topn-values", default=None)
    parser.add_argument("--probability-threshold", type=float, default=0.0)
    parser.add_argument("--probability-thresholds", default=None)
    parser.add_argument("--grid-probability-thresholds", default=None)
    parser.add_argument("--win5-payout-csv", default=None)
    parser.add_argument("--payout-date-column", default="date")
    parser.add_argument("--payout-amount-column", default="payout")
    parser.add_argument("--buy-expected-value-source", choices=["actual", "estimated", "auto"], default="auto")
    parser.add_argument("--min-expected-value", type=float, default=0.0)
    parser.add_argument("--min-expected-values", default=None)
    parser.add_argument("--grid-min-expected-values", default=None)
    parser.add_argument("--max-probability-sum", type=float, default=0.0)
    parser.add_argument("--max-bet-amount", type=int, default=0)
    parser.add_argument("--dynamic-topn", action="store_true")
    parser.add_argument("--dynamic-topn-threshold", type=float, default=0.05)
    parser.add_argument("--dynamic-topn-max", type=int, default=6)
    parser.add_argument("--selection-mode", choices=["late5", "last5", "jra_win5_rule"], default="late5")
    parser.add_argument("--auto-select-optimal-pattern", action="store_true")
    parser.add_argument("--min-race-num", type=int, default=10)
    parser.add_argument("--required-races", type=int, default=5)
    parser.add_argument("--ticket-unit", type=int, default=100)
    parser.add_argument("--max-patterns-output", type=int, default=20)
    parser.add_argument("--preview-days", type=int, default=5)
    parser.add_argument("--device", default="cuda" if torch.cuda.is_available() else "cpu")
    return parser


def main() -> None:
    args = build_arg_parser().parse_args()
    model_path_list = [args.model_path] + parse_ensemble_model_paths(args.ensemble_model_paths)
    checkpoints = load_checkpoints(
        model_path=args.model_path,
        ensemble_model_paths_text=args.ensemble_model_paths,
        device=args.device,
    )
    ensemble_weights = parse_ensemble_weights(args.ensemble_weights, len(model_path_list))
    checkpoint_config, feature_columns = validate_checkpoint_compatibility(checkpoints)

    dataframe = load_backtest_dataframe(
        database_name=args.database_name,
        table_name=args.table_name,
        race_date_col=args.race_date_col,
        min_race_date=checkpoint_config.get("min_race_date", "2024-01-01"),
        feature_columns=feature_columns,
        target_col=args.target_col,
        num_classes=int(checkpoint_config.get("num_classes", 18)),
        zero_feature_columns=checkpoint_config.get("zero_feature_columns"),
    )
    if "feature_2" in dataframe.columns:
        dataframe["raw_feature_2"] = pd.to_numeric(dataframe["feature_2"], errors="coerce")
    dataframe = apply_scaler_from_history(
        dataframe=dataframe,
        feature_columns=feature_columns,
        race_date_col=args.race_date_col,
        backtest_start_date=args.backtest_start_date,
        standardize_features=bool(checkpoint_config.get("standardize_features", True)),
    )

    start_date = pd.Timestamp(args.backtest_start_date)
    end_date = pd.Timestamp(args.backtest_end_date) if args.backtest_end_date else dataframe[args.race_date_col].max()
    evaluation_dataframe = dataframe.loc[
        dataframe[args.race_date_col].between(start_date, end_date)
    ].copy()
    if evaluation_dataframe.empty:
        raise ValueError("指定期間にバックテスト対象データがありません")

    models: list[torch.nn.Module] = []
    for checkpoint in checkpoints:
        config = checkpoint["config"]
        model = build_win5_resnet_model(
            input_dim=int(config.get("input_dim", len(feature_columns))),
            num_classes=int(config.get("num_classes", 18)),
            hidden_dim=int(config.get("hidden_dim", 256)),
            num_blocks=int(config.get("num_blocks", 4)),
            dropout=float(config.get("dropout", 0.1)),
            device=args.device,
        )
        model.load_state_dict(checkpoint["model_state_dict"])
        models.append(model)

    scored = score_races(
        dataframe=evaluation_dataframe,
        models=models,
        ensemble_weights=ensemble_weights,
        feature_columns=feature_columns,
        race_date_col=args.race_date_col,
        device=torch.device(args.device),
    )
    summary = summarize_topn_backtest(scored, top_n=args.top_n)
    topn_patterns = build_topn_patterns(
        top_n=args.top_n,
        top_n_patterns_arg=args.top_n_patterns,
        grid_topn_values_arg=args.grid_topn_values,
        required_races=args.required_races,
    )
    probability_thresholds = build_probability_threshold_grid(
        probability_threshold=args.probability_threshold,
        probability_thresholds_arg=args.probability_thresholds,
        grid_probability_thresholds_arg=args.grid_probability_thresholds,
    )
    min_expected_values = build_expected_value_threshold_grid(
        min_expected_value=args.min_expected_value,
        min_expected_values_arg=args.min_expected_values,
        grid_min_expected_values_arg=args.grid_min_expected_values,
    )
    schedule_dataframe = load_race_schedule_metadata(start_date=start_date, end_date=end_date)
    payout_dataframe = load_win5_payouts(
        csv_path=args.win5_payout_csv,
        payout_date_column=args.payout_date_column,
        payout_amount_column=args.payout_amount_column,
    )
    win5_summary, win5_daily_results, grouped_day_count = evaluate_win5_patterns(
        scored_dataframe=scored,
        race_date_col=args.race_date_col,
        selection_mode=args.selection_mode,
        min_race_num=args.min_race_num,
        required_races=args.required_races,
        topn_patterns=topn_patterns,
        ticket_unit=args.ticket_unit,
        probability_thresholds=probability_thresholds,
        schedule_dataframe=schedule_dataframe,
        payout_dataframe=payout_dataframe,
        min_expected_values=min_expected_values,
        buy_expected_value_source=args.buy_expected_value_source,
        max_probability_sum=(float(args.max_probability_sum) if float(args.max_probability_sum) > 0.0 else None),
        max_bet_amount=(int(args.max_bet_amount) if int(args.max_bet_amount) > 0 else None),
        dynamic_topn_enabled=bool(args.dynamic_topn),
        dynamic_topn_threshold=float(args.dynamic_topn_threshold),
        dynamic_topn_max=int(args.dynamic_topn_max),
    )

    print(f"model_path={Path(args.model_path)}")
    print(f"ensemble_model_count={len(model_path_list)}")
    print(f"ensemble_model_paths={','.join(str(Path(path)) for path in model_path_list)}")
    print(f"ensemble_weights={','.join(f'{weight:.6f}' for weight in ensemble_weights)}")
    print(f"backtest_period={start_date.date()}..{end_date.date()}")
    print(f"race_count={int(summary['race_count'])}")
    print(f"top_n={int(summary['topn'])}")
    print(f"race_hit_rate={summary['race_hit_rate']:.4f}")
    print(f"average_tickets_per_race={summary['average_tickets_per_race']:.2f}")
    print(f"average_winner_probability={summary['average_winner_probability']:.4f}")
    print(f"grouped_day_count={grouped_day_count}")
    print(f"selection_mode={args.selection_mode}")
    print(f"ticket_unit_yen={args.ticket_unit}")
    print(f"payout_csv={Path(args.win5_payout_csv) if args.win5_payout_csv else 'none'}")
    print(f"buy_expected_value_source={args.buy_expected_value_source}")
    print(f"max_probability_sum={float(args.max_probability_sum):.6f}")
    print(f"max_bet_amount={int(args.max_bet_amount)}")
    print(f"dynamic_topn={int(bool(args.dynamic_topn))}")
    print(f"dynamic_topn_threshold={float(args.dynamic_topn_threshold):.4f}")
    print(f"dynamic_topn_max={int(args.dynamic_topn_max)}")

    if win5_summary.empty:
        print("win5_pattern_summary=利用可能な5レース日がありません")
    else:
        print("win5_pattern_summary=")
        print(
            win5_summary.head(args.max_patterns_output).to_string(
                index=False,
                formatters={
                    "purchase_rate": "{:.4f}".format,
                    "win5_hit_rate": "{:.4f}".format,
                    "bought_hit_rate": "{:.4f}".format,
                    "probability_threshold": "{:.6f}".format,
                    "min_expected_value": "{:.4f}".format,
                    "max_probability_sum": "{:.6f}".format,
                    "max_bet_amount": "{:.0f}".format,
                    "average_ticket_count": "{:.2f}".format,
                    "average_raw_ticket_count": "{:.2f}".format,
                    "average_cost_yen": "{:.2f}".format,
                    "average_selected_probability_sum": "{:.6f}".format,
                    "average_expected_value_ratio": "{:.4f}".format,
                    "total_cost_yen": "{:.0f}".format,
                    "total_return_yen": "{:.0f}".format,
                    "total_profit_yen": "{:.0f}".format,
                    "roi": "{:.4f}".format,
                    "estimated_total_return_yen": "{:.0f}".format,
                    "estimated_total_profit_yen": "{:.0f}".format,
                    "estimated_roi": "{:.4f}".format,
                    "payout_correlation": "{:.4f}".format,
                },
            )
        )

        best_pattern = str(win5_summary.iloc[0]["pattern"])
        best_threshold = float(win5_summary.iloc[0]["probability_threshold"])
        best_min_expected_value = float(win5_summary.iloc[0]["min_expected_value"])
        best_key = f"{best_pattern}|{best_threshold:.6f}|{best_min_expected_value:.6f}"
        print(f"best_pattern={best_pattern}")
        print(f"best_probability_threshold={best_threshold:.6f}")
        print(f"best_min_expected_value={best_min_expected_value:.4f}")
        print("best_pattern_daily_preview=")
        print(win5_daily_results[best_key].head(args.preview_days).to_string(index=False))

        if args.auto_select_optimal_pattern:
            auto_selected_daily = build_auto_selected_daily_patterns(win5_daily_results)
            if auto_selected_daily.empty:
                print("auto_selected_optimal_patterns=利用可能な候補がありません")
            else:
                print("auto_selected_optimal_patterns=")
                print(
                    auto_selected_daily[
                        [
                            "race_date",
                            "pattern",
                            "ticket_count",
                            "cost_yen",
                            "selected_probability_sum",
                            "buy_expected_payout_yen",
                            "expected_return_yen",
                            "expected_value_ratio",
                            "all_hit",
                            "bought_hit",
                        ]
                    ].to_string(
                        index=False,
                        formatters={
                            "selected_probability_sum": "{:.6f}".format,
                            "buy_expected_payout_yen": "{:.0f}".format,
                            "expected_return_yen": "{:.2f}".format,
                            "expected_value_ratio": "{:.4f}".format,
                        },
                    )
                )
                print(
                    "auto_selected_summary="
                    f"day_count={len(auto_selected_daily)} "
                    f"hit_count={int(auto_selected_daily['all_hit'].sum())} "
                    f"bought_hit_count={int(auto_selected_daily['bought_hit'].sum())} "
                    f"total_cost_yen={int(auto_selected_daily['actual_cost_yen'].sum())} "
                    f"total_expected_return_yen={float(auto_selected_daily['expected_return_yen'].sum()):.2f}"
                )

    print("note=buy_expected_value_source=estimated では feature_2 の単勝オッズ近似に本命サイド補正を掛けた推定配当を使います。--max-probability-sum で高確率すぎる日を見送り、--max-bet-amount で確率上位の買い目だけに物理的に絞れます")

    preview_columns = ["race_id", args.race_date_col, "uma_ban", "target_class", "predicted_win_probability", "predicted_rank"]
    print("top_predictions_preview=")
    print(scored[preview_columns].groupby("race_id").head(args.top_n).head(30).to_string(index=False))


if __name__ == "__main__":
    main()