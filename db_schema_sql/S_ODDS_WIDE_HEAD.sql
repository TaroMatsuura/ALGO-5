-- Table structure for table `S_ODDS_WIDE_HEAD`
-- Table structure for table `S_ODDS_WIDE_HEAD`
--

DROP TABLE IF EXISTS `S_ODDS_WIDE_HEAD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_ODDS_WIDE_HEAD` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=O3でレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=1:中間/2:前日売最終/3:最終/4:確定/5:確定(月)/9:中止/0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_ODDS_WIDE_HEAD; class=速報系; unit=yyyymmdd; doc=12-3-19-ODDS_WIDE_HEAD; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_ODDS_WIDE_HEAD; class=速報系; unit=yyyy; doc=12-3-19-ODDS_WIDE_HEAD; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_ODDS_WIDE_HEAD; class=速報系; unit=mmdd; doc=12-3-19-ODDS_WIDE_HEAD; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_ODDS_WIDE_HEAD; class=速報系; ref=code:2001; doc=12-3-19-ODDS_WIDE_HEAD; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=該当レース番号',
  `HappyoTime` varchar(8) DEFAULT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_ODDS_WIDE_HEAD; class=速報系; unit=mmddHHMM; doc=12-3-19-ODDS_WIDE_HEAD; desc=中間オッズのみ設定/時系列オッズ使用時はキー',
  `TorokuTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=登録頭数; column=TorokuTosu; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=出馬表発表時の登録頭数',
  `SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=出走頭数; column=SyussoTosu; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=取消･除外反映後の出走頭数',
  `WideFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(ワイド); column=WideFlag; table=S_ODDS_WIDE_HEAD; class=速報系; doc=12-3-19-ODDS_WIDE_HEAD; desc=0発売なし/1発売前取消/3発売後取消/7発売あり',
  `TotalHyosuWide` varchar(11) DEFAULT NULL COMMENT '[COL] name=ワイド票数合計; column=TotalHyosuWide; table=S_ODDS_WIDE_HEAD; class=速報系; unit=百円; doc=12-3-19-ODDS_WIDE_HEAD; desc=返還分票数を含む合計',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=オッズ_ワイド_ヘッダ; table=S_ODDS_WIDE_HEAD; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
