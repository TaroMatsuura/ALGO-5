from __future__ import annotations

import argparse
import math
import os
from pathlib import Path
import re

import pandas as pd
import pymysql
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL


FEATURE_COUNT = 128


def validate_identifier(identifier: str) -> str:
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", identifier):
        raise ValueError(f"不正な識別子です: {identifier}")
    return identifier


def clamp01(series: pd.Series) -> pd.Series:
    return series.clip(lower=0.0, upper=1.0).fillna(0.0)


def minmax_normalize(series: pd.Series, min_value: float, max_value: float) -> pd.Series:
    denominator = max_value - min_value
    if denominator <= 0:
        raise ValueError("max_value は min_value より大きい必要があります")
    return clamp01((series - min_value) / denominator)


def compute_starts_since_layoff(
    dataframe: pd.DataFrame,
    horse_id_col: str = "horse_id",
    race_date_col: str = "race_date",
    layoff_threshold_days: int = 90,
) -> pd.Series:
    ordered = dataframe[[horse_id_col, race_date_col]].copy()
    ordered[race_date_col] = pd.to_datetime(ordered[race_date_col], errors="coerce")
    ordered = ordered.sort_values([horse_id_col, race_date_col]).copy()
    counted = pd.Series(index=ordered.index, dtype="float64")

    for _, group in ordered.groupby(horse_id_col, sort=False):
        counts: list[int] = []
        current_count = 0
        previous_date = pd.NaT

        for race_date in group[race_date_col]:
            if pd.isna(previous_date) or pd.isna(race_date):
                current_count = 1
            else:
                gap_days = (race_date - previous_date).days
                current_count = 1 if gap_days >= layoff_threshold_days else current_count + 1

            counts.append(current_count)
            previous_date = race_date

        counted.loc[group.index] = counts

    return counted.reindex(dataframe.index).fillna(1.0)


def compute_groupwise_past3_average(
    dataframe: pd.DataFrame,
    group_columns: list[str],
    value_column: str,
    order_column: str = "race_date",
) -> pd.Series:
    ordered_columns = group_columns + [order_column, value_column]
    ordered = dataframe[ordered_columns].copy()
    ordered[order_column] = pd.to_datetime(ordered[order_column], errors="coerce")
    ordered[value_column] = pd.to_numeric(ordered[value_column], errors="coerce")
    ordered = ordered.sort_values(group_columns + [order_column]).copy()

    history = (
        ordered.groupby(group_columns, group_keys=False)[value_column]
        .transform(lambda series: series.shift(1).rolling(3, min_periods=1).mean())
    )
    return history.reindex(dataframe.index)


def compute_groupwise_shifted_past3_average(
    dataframe: pd.DataFrame,
    group_columns: list[str],
    value_column: str,
    order_column: str = "race_date",
) -> pd.Series:
    ordered_columns = group_columns + [order_column, value_column]
    ordered = dataframe[ordered_columns].copy()
    ordered[order_column] = pd.to_datetime(ordered[order_column], errors="coerce")
    ordered[value_column] = pd.to_numeric(ordered[value_column], errors="coerce")
    ordered = ordered.sort_values(group_columns + [order_column]).copy()

    history = (
        ordered.groupby(group_columns, group_keys=False)[value_column]
        .transform(lambda series: series.shift(1).rolling(3, min_periods=1).mean())
    )
    return history.reindex(dataframe.index)


def load_db_settings(env_path: str | Path) -> dict[str, object]:
    load_dotenv(dotenv_path=Path(env_path))

    required_keys = ("DB_HOST", "DB_USER", "DB_PASSWORD")
    missing_keys = [key for key in required_keys if not os.getenv(key)]
    if missing_keys:
        raise ValueError(f".env に必要な接続情報がありません: {', '.join(missing_keys)}")

    return {
        "host": os.environ["DB_HOST"],
        "user": os.environ["DB_USER"],
        "password": os.environ["DB_PASSWORD"],
        "port": int(os.getenv("DB_PORT", "3306")),
    }


def create_sqlalchemy_engine(settings: dict[str, object], database: str):
    url = URL.create(
        drivername="mysql+pymysql",
        username=str(settings["user"]),
        password=str(settings["password"]),
        host=str(settings["host"]),
        port=int(settings["port"]),
        database=database,
    )
    return create_engine(url, future=True)


def split_min_race_date(min_race_date: str) -> tuple[int, str]:
    parsed = pd.Timestamp(min_race_date)
    return parsed.year, parsed.strftime("%m%d")


def fetch_raw_training_data(
    engine,
    raw_database: str,
    min_race_date: str,
) -> pd.DataFrame:
    raw_database = validate_identifier(raw_database)
    min_year, min_month_day = split_min_race_date(min_race_date)
    query = text(
        f"""
        WITH current_races AS (
            SELECT
                ur.Year,
                ur.MonthDay,
                ur.JyoCD,
                ur.Kaiji,
                ur.Nichiji,
                ur.RaceNum,
                ur.KettoNum,
                ur.Umaban,
                STR_TO_DATE(CONCAT(ur.Year, ur.MonthDay), '%Y%m%d') AS race_date
            FROM {raw_database}.N_UMA_RACE AS ur
            WHERE (
                ur.Year > :min_year
                OR (ur.Year = :min_year AND ur.MonthDay >= :min_month_day)
            )
            AND ur.KakuteiJyuni REGEXP '^[0-9]{{1,2}}$'
        ),
        target_horses AS (
            SELECT DISTINCT KettoNum
            FROM current_races
        ),
        horse_history AS (
            SELECT
                ur.Year,
                ur.MonthDay,
                ur.JyoCD,
                ur.Kaiji,
                ur.Nichiji,
                ur.RaceNum,
                ur.KettoNum,
                ur.Bamei,
                ur.Wakuban,
                ur.Umaban,
                ur.Futan,
                ur.Barei,
                ur.SexCD,
                ur.BaTaijyu,
                ur.ZogenFugo,
                ur.ZogenSa,
                ur.Ninki,
                COALESCE(ot.TanOdds, ur.Odds) AS CurrentTanOdds,
                ur.HaronTimeL3,
                ur.KakuteiJyuni,
                ur.TimeDiff,
                ra.Kyori,
                ra.TrackCD,
                ra.SyussoTosu,
                ra.GradeCD,
                ra.TenkoCD,
                ra.SibaBabaCD,
                ra.DirtBabaCD,
                STR_TO_DATE(CONCAT(ur.Year, ur.MonthDay), '%Y%m%d') AS race_date,
                LAG(STR_TO_DATE(CONCAT(ur.Year, ur.MonthDay), '%Y%m%d')) OVER horse_window AS prev_race_date,
                LAG(ur.KakuteiJyuni) OVER horse_window AS prev_finish_position_raw,
                LAG(ur.TimeDiff) OVER horse_window AS prev_time_diff_raw,
                LAG(ur.HaronTimeL3) OVER horse_window AS prev_agari_3f_raw,
                LAG(ra.Kyori) OVER horse_window AS prev_distance_raw,
                LAG(ra.TrackCD) OVER horse_window AS prev_track_cd,
                LAG(ur.Ninki) OVER horse_window AS prev_popularity_raw,
                LAG(COALESCE(ot.TanOdds, ur.Odds)) OVER horse_window AS prev_win_odds_raw,
                LAG(ur.ZogenFugo) OVER horse_window AS prev_body_weight_diff_sign,
                LAG(ur.ZogenSa) OVER horse_window AS prev_body_weight_diff_raw,
                LAG(ur.Futan) OVER horse_window AS prev_carried_weight_raw,
                LAG(ra.SyussoTosu) OVER horse_window AS prev_field_size_raw,
                LAG(ra.GradeCD) OVER horse_window AS prev_grade_cd
            FROM {raw_database}.N_UMA_RACE AS ur
            INNER JOIN target_horses AS th
                ON ur.KettoNum = th.KettoNum
            LEFT JOIN {raw_database}.N_ODDS_TANPUKU AS ot
                ON ur.Year = ot.Year
                AND ur.JyoCD = ot.JyoCD
                AND ur.Kaiji = ot.Kaiji
                AND ur.Nichiji = ot.Nichiji
                AND ur.RaceNum = ot.RaceNum
                AND ur.Umaban = ot.Umaban
            LEFT JOIN {raw_database}.N_RACE AS ra
                ON ur.Year = ra.Year
                AND ur.MonthDay = ra.MonthDay
                AND ur.JyoCD = ra.JyoCD
                AND ur.Kaiji = ra.Kaiji
                AND ur.Nichiji = ra.Nichiji
                AND ur.RaceNum = ra.RaceNum
            WINDOW horse_window AS (
                PARTITION BY ur.KettoNum
                ORDER BY STR_TO_DATE(CONCAT(ur.Year, ur.MonthDay), '%Y%m%d'), ur.Year, ur.JyoCD, ur.Kaiji, ur.Nichiji, ur.RaceNum
            )
        )
        SELECT
            hh.race_date,
            hh.Year AS race_year,
            hh.MonthDay AS race_month_day,
            hh.JyoCD AS jyo_cd,
            hh.Kaiji AS kaiji,
            hh.Nichiji AS nichiji,
            hh.RaceNum AS race_num,
            hh.KettoNum AS horse_id,
            hh.Bamei AS horse_name,
            hh.Wakuban AS wakuban,
            hh.Umaban AS umaban,
            hh.Futan AS carried_weight_raw,
            hh.Barei AS horse_age,
            hh.SexCD AS sex_cd,
            hh.BaTaijyu AS body_weight_raw,
            hh.ZogenFugo AS body_weight_diff_sign,
            hh.ZogenSa AS body_weight_diff_raw,
            hh.Ninki AS popularity_raw,
            hh.CurrentTanOdds AS win_odds_raw,
            hh.HaronTimeL3 AS agari_3f_raw,
            hh.KakuteiJyuni AS finish_position_raw,
            hh.TimeDiff AS time_diff_raw,
            hh.Kyori AS distance_raw,
            hh.TrackCD AS track_cd,
            hh.SyussoTosu AS field_size_raw,
            hh.GradeCD AS grade_cd,
            hh.TenkoCD AS weather_cd,
            hh.SibaBabaCD AS turf_condition_cd,
            hh.DirtBabaCD AS dirt_condition_cd,
            hh.prev_race_date,
            hh.prev_finish_position_raw,
            hh.prev_time_diff_raw,
            hh.prev_agari_3f_raw,
            hh.prev_distance_raw,
            hh.prev_track_cd,
            hh.prev_popularity_raw,
            hh.prev_win_odds_raw,
            hh.prev_body_weight_diff_sign,
            hh.prev_body_weight_diff_raw,
            hh.prev_carried_weight_raw,
            hh.prev_field_size_raw,
            hh.prev_grade_cd
        FROM horse_history AS hh
        INNER JOIN current_races AS cr
            ON hh.Year = cr.Year
            AND hh.MonthDay = cr.MonthDay
            AND hh.JyoCD = cr.JyoCD
            AND hh.Kaiji = cr.Kaiji
            AND hh.Nichiji = cr.Nichiji
            AND hh.RaceNum = cr.RaceNum
            AND hh.KettoNum = cr.KettoNum
            AND hh.Umaban = cr.Umaban
        ORDER BY hh.race_date, hh.JyoCD, hh.Kaiji, hh.Nichiji, hh.RaceNum, hh.Umaban
        """
    )

    with engine.connect() as connection:
        return pd.read_sql_query(
            query,
            connection,
            params={
                "min_year": min_year,
                "min_month_day": min_month_day,
            },
        )


def create_feature_frame(raw_dataframe: pd.DataFrame) -> pd.DataFrame:
    dataframe = raw_dataframe.copy()

    def parse_time_diff(series: pd.Series) -> pd.Series:
        text = series.fillna("").astype(str).str.strip()
        valid = text.str.match(r"^[+-][0-9]{3}$")
        numeric = pd.to_numeric(text.where(valid).str[1:], errors="coerce") / 10.0
        return numeric.where(text.where(valid).str[0] != "-", -numeric)

    dataframe["race_date"] = pd.to_datetime(dataframe["race_date"], errors="coerce")
    dataframe["prev_race_date"] = pd.to_datetime(dataframe["prev_race_date"], errors="coerce")
    dataframe["umaban"] = pd.to_numeric(dataframe["umaban"], errors="coerce")
    dataframe["wakuban"] = pd.to_numeric(dataframe["wakuban"], errors="coerce")
    dataframe["carried_weight_kg"] = pd.to_numeric(dataframe["carried_weight_raw"], errors="coerce") / 10.0
    dataframe["win_odds"] = pd.to_numeric(dataframe["win_odds_raw"], errors="coerce") / 10.0
    dataframe["popularity"] = pd.to_numeric(dataframe["popularity_raw"], errors="coerce")
    dataframe["body_weight"] = pd.to_numeric(dataframe["body_weight_raw"], errors="coerce")
    dataframe["body_weight_diff"] = pd.to_numeric(dataframe["body_weight_diff_raw"], errors="coerce")
    dataframe["body_weight_diff"] = dataframe["body_weight_diff"].where(
        dataframe["body_weight_diff_sign"] != "-",
        -dataframe["body_weight_diff"],
    )
    dataframe["horse_age"] = pd.to_numeric(dataframe["horse_age"], errors="coerce")
    dataframe["distance"] = pd.to_numeric(dataframe["distance_raw"], errors="coerce")
    dataframe["field_size"] = pd.to_numeric(dataframe["field_size_raw"], errors="coerce")
    dataframe["agari_3f"] = pd.to_numeric(dataframe["agari_3f_raw"], errors="coerce") / 10.0
    dataframe["finish_position"] = pd.to_numeric(dataframe["finish_position_raw"], errors="coerce")
    dataframe["time_diff_seconds"] = parse_time_diff(dataframe["time_diff_raw"])
    dataframe["prev_finish_position"] = pd.to_numeric(dataframe["prev_finish_position_raw"], errors="coerce")
    dataframe["prev_time_diff_seconds"] = parse_time_diff(dataframe["prev_time_diff_raw"])
    dataframe["prev_agari_3f"] = pd.to_numeric(dataframe["prev_agari_3f_raw"], errors="coerce") / 10.0
    dataframe["prev_distance"] = pd.to_numeric(dataframe["prev_distance_raw"], errors="coerce")
    dataframe["prev_popularity"] = pd.to_numeric(dataframe["prev_popularity_raw"], errors="coerce")
    dataframe["prev_win_odds"] = pd.to_numeric(dataframe["prev_win_odds_raw"], errors="coerce") / 10.0
    dataframe["prev_body_weight_diff"] = pd.to_numeric(dataframe["prev_body_weight_diff_raw"], errors="coerce")
    dataframe["prev_body_weight_diff"] = dataframe["prev_body_weight_diff"].where(
        dataframe["prev_body_weight_diff_sign"] != "-",
        -dataframe["prev_body_weight_diff"],
    )
    dataframe["prev_carried_weight_kg"] = pd.to_numeric(dataframe["prev_carried_weight_raw"], errors="coerce") / 10.0
    dataframe["prev_field_size"] = pd.to_numeric(dataframe["prev_field_size_raw"], errors="coerce")
    dataframe["days_since_prev"] = (dataframe["race_date"] - dataframe["prev_race_date"]).dt.days
    dataframe["starts_since_layoff"] = compute_starts_since_layoff(dataframe)
    dataframe["same_course_distance_avg_finish"] = compute_groupwise_past3_average(
        dataframe=dataframe,
        group_columns=["horse_id", "jyo_cd", "distance"],
        value_column="finish_position",
    )

    race_group_columns = ["race_year", "race_month_day", "jyo_cd", "kaiji", "nichiji", "race_num"]
    dataframe["agari_rank_in_race"] = dataframe.groupby(race_group_columns)["agari_3f"].rank(
        method="average",
        ascending=True,
    )
    denominator = (dataframe["field_size"].fillna(1.0) - 1.0).clip(lower=1.0)
    dataframe["agari_rank_score"] = clamp01(1.0 - (dataframe["agari_rank_in_race"].fillna(dataframe["field_size"].fillna(1.0)) - 1.0) / denominator)

    dataframe["time_diff_score"] = clamp01(1.0 - dataframe["time_diff_seconds"].clip(lower=0.0).fillna(2.5) / 2.5)
    dataframe["agari_3f_score"] = clamp01(1.0 - (dataframe["agari_3f"].fillna(40.0) - 32.0) / 8.0)
    dataframe["speed_figure"] = clamp01(
        0.65 * dataframe["time_diff_score"]
        + 0.35 * dataframe["agari_3f_score"]
    )
    dataframe["past3_speed_figure"] = compute_groupwise_shifted_past3_average(
        dataframe=dataframe,
        group_columns=["horse_id"],
        value_column="speed_figure",
    )
    dataframe["past3_agari_rank_score"] = compute_groupwise_shifted_past3_average(
        dataframe=dataframe,
        group_columns=["horse_id"],
        value_column="agari_rank_score",
    )

    feature_frame = pd.DataFrame(
        0.0,
        index=dataframe.index,
        columns=[f"feature_{feature_index}" for feature_index in range(FEATURE_COUNT)],
    )

    feature_frame["feature_0"] = minmax_normalize(dataframe["wakuban"], 1.0, 8.0)
    feature_frame["feature_1"] = minmax_normalize(dataframe["carried_weight_kg"], 48.0, 62.0)
    feature_frame["feature_2"] = clamp01(dataframe["win_odds"].fillna(0.0) / 100.0)
    feature_frame["feature_3"] = clamp01((18.0 - dataframe["popularity"].fillna(18.0)) / 17.0)
    feature_frame["feature_4"] = minmax_normalize(dataframe["body_weight"], 400.0, 600.0)
    feature_frame["feature_5"] = minmax_normalize(dataframe["body_weight_diff"], -30.0, 30.0)
    feature_frame["feature_6"] = minmax_normalize(dataframe["horse_age"], 2.0, 8.0)
    feature_frame["feature_7"] = minmax_normalize(dataframe["distance"], 1000.0, 3600.0)
    feature_frame["feature_8"] = minmax_normalize(dataframe["field_size"], 5.0, 18.0)
    feature_frame["feature_9"] = minmax_normalize(dataframe["agari_3f"], 32.0, 40.0)
    feature_frame["feature_10"] = clamp01(dataframe["race_date"].dt.month.fillna(1).astype(float) / 12.0)
    feature_frame["feature_11"] = clamp01(dataframe["race_date"].dt.dayofweek.fillna(0).astype(float) / 6.0)
    feature_frame["feature_12"] = clamp01(pd.to_numeric(dataframe["umaban"], errors="coerce") / 18.0)

    sex_map = {"1": 0.0, "2": 0.5, "3": 1.0}
    feature_frame["feature_13"] = dataframe["sex_cd"].map(sex_map).fillna(0.5)

    track_map = {
        "10": 0.2,
        "11": 0.25,
        "12": 0.3,
        "13": 0.35,
        "20": 0.6,
        "21": 0.65,
        "22": 0.7,
        "23": 0.75,
        "30": 0.9,
    }
    feature_frame["feature_14"] = dataframe["track_cd"].map(track_map).fillna(0.0)

    grade_map = {"A": 1.0, "B": 0.85, "C": 0.7, "D": 0.55, "E": 0.4, "F": 0.25, "G": 0.1}
    feature_frame["feature_15"] = dataframe["grade_cd"].map(grade_map).fillna(0.0)

    weather_map = {"1": 0.0, "2": 0.2, "3": 0.4, "4": 0.6, "5": 0.8, "6": 1.0}
    feature_frame["feature_16"] = dataframe["weather_cd"].map(weather_map).fillna(0.0)

    baba_map = {"1": 0.0, "2": 0.33, "3": 0.66, "4": 1.0}
    feature_frame["feature_17"] = dataframe["turf_condition_cd"].map(baba_map).fillna(0.0)
    feature_frame["feature_18"] = dataframe["dirt_condition_cd"].map(baba_map).fillna(0.0)
    feature_frame["feature_20"] = clamp01(1.0 - dataframe["prev_time_diff_seconds"].clip(lower=0.0).fillna(2.0) / 2.0)
    feature_frame["feature_21"] = clamp01((18.0 - dataframe["prev_finish_position"].fillna(18.0)) / 17.0)
    feature_frame["feature_22"] = minmax_normalize(dataframe["prev_agari_3f"].fillna(40.0), 32.0, 40.0)
    feature_frame["feature_23"] = clamp01(1.0 - dataframe["days_since_prev"].fillna(180.0) / 180.0)
    feature_frame["feature_24"] = clamp01(1.0 - (dataframe["distance"] - dataframe["prev_distance"]).abs().fillna(2000.0) / 2000.0)
    feature_frame["feature_25"] = (dataframe["track_cd"].fillna("") == dataframe["prev_track_cd"].fillna("__missing__")).astype(float)
    feature_frame["feature_26"] = clamp01((18.0 - dataframe["prev_popularity"].fillna(18.0)) / 17.0)
    feature_frame["feature_27"] = clamp01(dataframe["prev_win_odds"].fillna(100.0) / 100.0)
    feature_frame["feature_28"] = minmax_normalize(dataframe["prev_body_weight_diff"].fillna(0.0), -30.0, 30.0)
    feature_frame["feature_29"] = clamp01(1.0 - (dataframe["carried_weight_kg"] - dataframe["prev_carried_weight_kg"]).abs().fillna(14.0) / 14.0)

    condition_goodness_map = {"0": 0.5, "1": 1.0, "2": 0.7, "3": 0.4, "4": 0.1}
    turf_track_codes = {"10", "11", "12", "17", "18"}
    dirt_track_codes = {"20", "21", "23", "24", "29"}
    course_shape_map = {
        "01": 0.45,
        "02": 0.40,
        "03": 0.45,
        "04": 1.00,
        "05": 1.00,
        "06": 0.55,
        "07": 0.80,
        "08": 0.75,
        "09": 0.85,
        "10": 0.40,
    }

    selected_condition = pd.Series("0", index=dataframe.index, dtype="object")
    turf_mask = dataframe["track_cd"].isin(turf_track_codes)
    dirt_mask = dataframe["track_cd"].isin(dirt_track_codes)
    selected_condition = selected_condition.where(~turf_mask, dataframe["turf_condition_cd"].fillna("0"))
    selected_condition = selected_condition.where(~dirt_mask, dataframe["dirt_condition_cd"].fillna("0"))

    feature_frame["feature_30"] = selected_condition.map(condition_goodness_map).fillna(0.5)
    feature_frame["feature_31"] = minmax_normalize(dataframe["body_weight_diff"].fillna(0.0), -30.0, 30.0)
    feature_frame["feature_32"] = clamp01(dataframe["starts_since_layoff"].fillna(1.0) / 3.0)
    feature_frame["feature_33"] = dataframe["jyo_cd"].map(course_shape_map).fillna(0.5)
    feature_frame["feature_34"] = dataframe["weather_cd"].isin(["4", "5", "6"]).astype(float)

    body_weight_change_ratio = (
        dataframe["body_weight_diff"] / dataframe["body_weight"]
    ).replace([float("inf"), float("-inf")], pd.NA).fillna(0.0)
    feature_frame["feature_35"] = minmax_normalize(body_weight_change_ratio, -0.10, 0.10)

    feature_frame["feature_36"] = minmax_normalize(
        (dataframe["prev_carried_weight_kg"] - dataframe["carried_weight_kg"]).fillna(0.0),
        -6.0,
        6.0,
    )
    feature_frame["feature_37"] = clamp01(
        (18.0 - dataframe["same_course_distance_avg_finish"].fillna(9.5)) / 17.0
    )

    inner_good_mask = dataframe["umaban"].between(1.0, 3.0) & (selected_condition == "1")
    outer_bad_mask = dataframe["umaban"].between(15.0, 18.0) & (selected_condition == "4")
    feature_frame["feature_38"] = (inner_good_mask | outer_bad_mask).astype(float)

    feature_frame["feature_39"] = 0.5
    feature_frame.loc[dataframe["field_size"].fillna(0.0) <= 10.0, "feature_39"] = 0.0
    feature_frame.loc[dataframe["field_size"].fillna(0.0) >= 15.0, "feature_39"] = 1.0
    feature_frame["feature_40"] = clamp01(dataframe["past3_speed_figure"].fillna(0.5))
    feature_frame["feature_41"] = clamp01(dataframe["past3_agari_rank_score"].fillna(0.5))

    output = pd.DataFrame(
        {
            "race_id": (
                dataframe["race_year"].fillna("").astype(str).str.zfill(4)
                + dataframe["jyo_cd"].fillna("").astype(str).str.zfill(2)
                + dataframe["kaiji"].fillna("").astype(str).str.zfill(2)
                + dataframe["nichiji"].fillna("").astype(str).str.zfill(2)
                + dataframe["race_num"].fillna("").astype(str).str.zfill(2)
            ),
            "uma_ban": pd.to_numeric(dataframe["umaban"], errors="coerce").fillna(0).astype(int),
            "race_date": dataframe["race_date"].dt.date,
            "target_class": dataframe["finish_position"].astype("Int64") - 1,
        }
    )

    output = pd.concat([output, feature_frame], axis=1)
    output = output.loc[output["target_class"].between(0, 17)].copy()
    output = output.loc[output["uma_ban"].between(1, 18)].copy()
    output = output.drop_duplicates(subset=["race_id", "uma_ban"], keep="last").copy()
    output["target_class"] = output["target_class"].astype(int)
    output["race_id"] = output["race_id"].astype(str)
    output["uma_ban"] = output["uma_ban"].astype(int)

    feature_columns = [f"feature_{index}" for index in range(FEATURE_COUNT)]
    output[feature_columns] = output[feature_columns].fillna(0.0).astype(float)
    return output


def create_target_table(
    connection: pymysql.connections.Connection,
    target_database: str,
    target_table: str,
) -> None:
    target_database = validate_identifier(target_database)
    target_table = validate_identifier(target_table)
    feature_columns_sql = ",\n            ".join(
        [f"feature_{index} DOUBLE NOT NULL DEFAULT 0" for index in range(FEATURE_COUNT)]
    )
    create_database_sql = f"CREATE DATABASE IF NOT EXISTS {target_database} CHARACTER SET utf8mb4"
    create_table_sql = f"""
        CREATE TABLE IF NOT EXISTS {target_database}.{target_table} (
            race_id CHAR(12) NOT NULL,
            uma_ban TINYINT NOT NULL,
            race_date DATE NOT NULL,
            target_class TINYINT UNSIGNED NOT NULL,
            {feature_columns_sql},
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (race_id, uma_ban),
            KEY idx_race_date (race_date)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    """

    with connection.cursor() as cursor:
        cursor.execute(create_database_sql)
        cursor.execute(create_table_sql)

        cursor.execute(
            """
            SELECT COLUMN_NAME
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
            """,
            (target_database, target_table),
        )
        existing_columns = {row[0] for row in cursor.fetchall()}

        required_columns = {
            "race_id": "CHAR(12) NOT NULL",
            "uma_ban": "TINYINT NOT NULL",
            "race_date": "DATE NOT NULL",
            "target_class": "TINYINT UNSIGNED NOT NULL",
        }
        for feature_index in range(FEATURE_COUNT):
            required_columns[f"feature_{feature_index}"] = "FLOAT DEFAULT 0"

        for column_name, column_definition in required_columns.items():
            if column_name not in existing_columns:
                cursor.execute(
                    f"ALTER TABLE {target_database}.{target_table} ADD COLUMN {column_name} {column_definition}"
                )
    connection.commit()


def delete_existing_rows(
    connection: pymysql.connections.Connection,
    target_database: str,
    target_table: str,
    min_race_date: str,
) -> None:
    target_database = validate_identifier(target_database)
    target_table = validate_identifier(target_table)
    delete_sql = f"DELETE FROM {target_database}.{target_table} WHERE race_date >= %s"
    with connection.cursor() as cursor:
        cursor.execute(delete_sql, (min_race_date,))
    connection.commit()


def bulk_insert_dataframe(
    connection: pymysql.connections.Connection,
    dataframe: pd.DataFrame,
    target_database: str,
    target_table: str,
    batch_size: int,
) -> None:
    if dataframe.empty:
        print("no rows to insert")
        return

    target_database = validate_identifier(target_database)
    target_table = validate_identifier(target_table)

    columns = dataframe.columns.tolist()
    placeholders = ", ".join(["%s"] * len(columns))
    column_sql = ", ".join(columns)
    insert_sql = f"INSERT INTO {target_database}.{target_table} ({column_sql}) VALUES ({placeholders})"

    rows = [tuple(None if (isinstance(value, float) and math.isnan(value)) else value for value in row) for row in dataframe.itertuples(index=False, name=None)]

    with connection.cursor() as cursor:
        for start in range(0, len(rows), batch_size):
            batch_rows = rows[start : start + batch_size]
            cursor.executemany(insert_sql, batch_rows)
        connection.commit()


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="ALGO-5 学習データ生成スクリプト")
    parser.add_argument("--env-path", default=".env")
    parser.add_argument("--raw-database", default="jravantest")
    parser.add_argument("--target-database", default="algo_5_db")
    parser.add_argument("--target-table", default="algo5_training_data")
    parser.add_argument("--min-race-date", default="2024-01-01")
    parser.add_argument("--batch-size", type=int, default=5000)
    return parser


def main() -> None:
    args = build_arg_parser().parse_args()

    settings = load_db_settings(args.env_path)
    read_engine = create_sqlalchemy_engine(settings=settings, database=args.raw_database)
    print(f"fetch_raw_training_data start min_race_date={args.min_race_date}", flush=True)
    raw_dataframe = fetch_raw_training_data(
        engine=read_engine,
        raw_database=args.raw_database,
        min_race_date=args.min_race_date,
    )
    print(f"fetch_raw_training_data done rows={len(raw_dataframe)}", flush=True)
    feature_dataframe = create_feature_frame(raw_dataframe)
    print(f"create_feature_frame done rows={len(feature_dataframe)}", flush=True)

    write_connection = pymysql.connect(
        host=str(settings["host"]),
        user=str(settings["user"]),
        password=str(settings["password"]),
        port=int(settings["port"]),
        charset="utf8mb4",
        autocommit=False,
    )
    try:
        create_target_table(write_connection, args.target_database, args.target_table)
        print("create_target_table done", flush=True)
        delete_existing_rows(write_connection, args.target_database, args.target_table, args.min_race_date)
        print(f"delete_existing_rows done min_race_date={args.min_race_date}", flush=True)
        bulk_insert_dataframe(
            connection=write_connection,
            dataframe=feature_dataframe,
            target_database=args.target_database,
            target_table=args.target_table,
            batch_size=args.batch_size,
        )
        print("bulk_insert_dataframe done", flush=True)
    finally:
        write_connection.close()
        read_engine.dispose()

    print(f"generated_rows={len(feature_dataframe)}")
    print(f"target_table={args.target_database}.{args.target_table}")


if __name__ == "__main__":
    main()