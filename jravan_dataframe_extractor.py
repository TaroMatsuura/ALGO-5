from __future__ import annotations

from dataclasses import dataclass
from datetime import date
from pathlib import Path
import re

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine, URL


@dataclass(frozen=True)
class DatabaseSettings:
    host: str
    user: str
    password: str
    database: str
    port: int = 3306


class JravanDataFrameExtractor:
    def __init__(self, env_path: str | Path = ".env", database_name: str | None = None) -> None:
        env_file = Path(env_path)
        load_dotenv(dotenv_path=env_file)
        self._settings = self._load_settings(database_name=database_name)
        self._engine = self._create_engine(self._settings)

    @staticmethod
    def _load_settings(database_name: str | None = None) -> DatabaseSettings:
        import os

        required_keys = ("DB_HOST", "DB_USER", "DB_PASSWORD", "DB_NAME")
        missing_keys = [key for key in required_keys if not os.getenv(key)]
        if missing_keys:
            missing = ", ".join(missing_keys)
            raise ValueError(f".env に必要な接続情報がありません: {missing}")

        raw_port = os.getenv("DB_PORT", "3306")
        return DatabaseSettings(
            host=os.environ["DB_HOST"],
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASSWORD"],
            database=database_name or os.environ["DB_NAME"],
            port=int(raw_port),
        )

    @staticmethod
    def _create_engine(settings: DatabaseSettings) -> Engine:
        url = URL.create(
            drivername="mysql+pymysql",
            username=settings.user,
            password=settings.password,
            host=settings.host,
            port=settings.port,
            database=settings.database,
        )
        return create_engine(url, future=True)

    @staticmethod
    def _cutoff_date(years: int) -> date:
        if years <= 0:
            raise ValueError("years は 1 以上を指定してください")

        today = date.today()
        try:
            return today.replace(year=today.year - years)
        except ValueError:
            return today.replace(month=2, day=28, year=today.year - years)

    @staticmethod
    def _validate_identifier(identifier: str) -> str:
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", identifier):
            raise ValueError(f"不正な識別子です: {identifier}")
        return identifier

    @staticmethod
    def _to_numeric_series(series: pd.Series) -> pd.Series:
        numeric = pd.to_numeric(series, errors="coerce")
        if numeric.dropna().empty:
            return numeric.astype("float64")

        whole_values = numeric.dropna()
        if ((whole_values % 1) == 0).all() and whole_values.abs().median() >= 100:
            return numeric / 10.0

        return numeric.astype("float64")

    @classmethod
    def add_history_features(
        cls,
        race_results: pd.DataFrame,
        horse_id_col: str = "horse_id",
        race_date_col: str = "race_date",
        agari_3f_col: str = "agari_3f_time",
        fill_missing: str = "both",
    ) -> pd.DataFrame:
        valid_strategies = {"none", "mean", "flag", "both"}
        if fill_missing not in valid_strategies:
            raise ValueError(
                f"fill_missing は {sorted(valid_strategies)} のいずれかを指定してください"
            )

        required_columns = {horse_id_col, race_date_col, agari_3f_col}
        missing_columns = required_columns.difference(race_results.columns)
        if missing_columns:
            missing = ", ".join(sorted(missing_columns))
            raise KeyError(f"race_results に必要な列がありません: {missing}")

        dataframe = race_results.copy()
        dataframe[race_date_col] = pd.to_datetime(dataframe[race_date_col], errors="coerce")
        dataframe[agari_3f_col] = cls._to_numeric_series(dataframe[agari_3f_col])
        dataframe = dataframe.sort_values([horse_id_col, race_date_col]).reset_index(drop=True)

        grouped_dates = dataframe.groupby(horse_id_col)[race_date_col]
        grouped_agari = dataframe.groupby(horse_id_col)[agari_3f_col]

        previous_race_date = grouped_dates.shift(1)
        previous_agari = grouped_agari.shift(1)

        dataframe["days_since_previous_race"] = (
            dataframe[race_date_col] - previous_race_date
        ).dt.days.astype("float64")
        dataframe["avg_agari_3f_last_3"] = previous_agari.groupby(dataframe[horse_id_col]).transform(
            lambda series: series.rolling(window=3, min_periods=1).mean()
        )

        dataframe["days_since_previous_race_missing_flag"] = dataframe[
            "days_since_previous_race"
        ].isna().astype("int8")
        dataframe["avg_agari_3f_last_3_missing_flag"] = dataframe[
            "avg_agari_3f_last_3"
        ].isna().astype("int8")
        dataframe["is_first_start"] = previous_race_date.isna().astype("int8")

        if fill_missing in {"mean", "both"}:
            days_mean = dataframe["days_since_previous_race"].mean()
            agari_mean = dataframe["avg_agari_3f_last_3"].mean()

            if pd.notna(days_mean):
                dataframe["days_since_previous_race"] = dataframe[
                    "days_since_previous_race"
                ].fillna(days_mean)
            if pd.notna(agari_mean):
                dataframe["avg_agari_3f_last_3"] = dataframe[
                    "avg_agari_3f_last_3"
                ].fillna(agari_mean)

        if fill_missing == "mean":
            dataframe = dataframe.drop(
                columns=[
                    "days_since_previous_race_missing_flag",
                    "avg_agari_3f_last_3_missing_flag",
                ]
            )

        return dataframe

    def fetch_race_features(self, years: int = 5) -> pd.DataFrame:
        cutoff_date = self._cutoff_date(years)
        query = text(
            """
            SELECT
                STR_TO_DATE(CONCAT(r.Year, r.MonthDay), '%Y%m%d') AS race_date,
                r.Year AS race_year,
                r.MonthDay AS race_month_day,
                r.JyoCD AS jyo_cd,
                r.Kaiji AS kaiji,
                r.Nichiji AS nichiji,
                r.RaceNum AS race_num,
                r.KettoNum AS ketto_num,
                r.Bamei AS horse_name,
                r.Umaban AS umaban,
                CASE
                    WHEN r.BaTaijyu REGEXP '^[0-9]{3}$' AND r.BaTaijyu NOT IN ('000', '999')
                        THEN CAST(r.BaTaijyu AS UNSIGNED)
                    ELSE NULL
                END AS body_weight_kg,
                CASE
                    WHEN r.ZogenSa REGEXP '^[0-9]{3}$' AND r.ZogenSa NOT IN ('000', '999')
                        THEN CASE
                            WHEN r.ZogenFugo = '-' THEN -CAST(r.ZogenSa AS SIGNED)
                            ELSE CAST(r.ZogenSa AS SIGNED)
                        END
                    WHEN r.ZogenSa = '000' THEN 0
                    ELSE NULL
                END AS body_weight_diff_kg,
                CASE
                    WHEN o.TanOdds REGEXP '^[0-9]{4}$' AND o.TanOdds NOT IN ('0000', '9999')
                        THEN CAST(o.TanOdds AS UNSIGNED) / 10.0
                    ELSE NULL
                END AS win_odds,
                CASE
                    WHEN r.KakuteiJyuni REGEXP '^[0-9]{1,2}$'
                        THEN CAST(r.KakuteiJyuni AS UNSIGNED)
                    ELSE NULL
                END AS finish_position
            FROM N_UMA_RACE AS r
            LEFT JOIN N_ODDS_TANPUKU AS o
                ON r.Year = o.Year
                AND r.JyoCD = o.JyoCD
                AND r.Kaiji = o.Kaiji
                AND r.Nichiji = o.Nichiji
                AND r.RaceNum = o.RaceNum
                AND r.Umaban = o.Umaban
            WHERE STR_TO_DATE(CONCAT(r.Year, r.MonthDay), '%Y%m%d') >= :cutoff_date
            ORDER BY race_date, jyo_cd, kaiji, nichiji, race_num, umaban
            """
        )

        with self._engine.connect() as connection:
            dataframe = pd.read_sql_query(query, connection, params={"cutoff_date": cutoff_date})

        return dataframe

    def fetch_race_results_with_history_features(
        self,
        years: int = 5,
        table_name: str = "race_results",
        horse_id_col: str = "horse_id",
        race_date_col: str = "race_date",
        agari_3f_col: str = "agari_3f_time",
        fill_missing: str = "both",
    ) -> pd.DataFrame:
        validated_table = self._validate_identifier(table_name)
        validated_horse_id = self._validate_identifier(horse_id_col)
        validated_race_date = self._validate_identifier(race_date_col)
        validated_agari = self._validate_identifier(agari_3f_col)
        cutoff_date = self._cutoff_date(years)

        query = text(
            f"""
            SELECT *
            FROM {validated_table}
            WHERE {validated_race_date} >= :cutoff_date
            ORDER BY {validated_horse_id}, {validated_race_date}
            """
        )

        with self._engine.connect() as connection:
            race_results = pd.read_sql_query(query, connection, params={"cutoff_date": cutoff_date})

        return self.add_history_features(
            race_results=race_results,
            horse_id_col=validated_horse_id,
            race_date_col=validated_race_date,
            agari_3f_col=validated_agari,
            fill_missing=fill_missing,
        )

    def fetch_table_dataframe(
        self,
        table_name: str,
        years: int = 5,
        race_date_col: str = "race_date",
    ) -> pd.DataFrame:
        validated_table = self._validate_identifier(table_name)
        validated_race_date = self._validate_identifier(race_date_col)
        cutoff_date = self._cutoff_date(years)

        query = text(
            f"""
            SELECT *
            FROM {validated_table}
            WHERE {validated_race_date} >= :cutoff_date
            ORDER BY {validated_race_date}
            """
        )

        with self._engine.connect() as connection:
            return pd.read_sql_query(query, connection, params={"cutoff_date": cutoff_date})

    def close(self) -> None:
        self._engine.dispose()


if __name__ == "__main__":
    extractor = JravanDataFrameExtractor()
    try:
        df = extractor.fetch_race_features(years=5)
        print(df.head())
    finally:
        extractor.close()