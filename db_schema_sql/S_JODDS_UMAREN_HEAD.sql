-- Table structure for table `S_JODDS_UMAREN_HEAD`
-- Table structure for table `S_JODDS_UMAREN_HEAD`
--

DROP TABLE IF EXISTS `S_JODDS_UMAREN_HEAD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_JODDS_UMAREN_HEAD` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_JODDS_UMAREN_HEAD; class=速報系; doc=12-3-49-JODDS_UMAREN_HEAD; desc=O2でレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_JODDS_UMAREN_HEAD; class=速報系; doc=12-3-49-JODDS_UMAREN_HEAD; vals=1:中間 2:前日売最終 3:最終 4:確定 5:確定(月曜) 9:レース中止 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_JODDS_UMAREN_HEAD; class=速報系; unit=yyyymmdd; doc=12-3-49-JODDS_UMAREN_HEAD',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_JODDS_UMAREN_HEAD; class=速報系; unit=yyyy; key=○; doc=12-3-49-JODDS_UMAREN_HEAD',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_JODDS_UMAREN_HEAD; class=速報系; unit=mmdd; key=○; doc=12-3-49-JODDS_UMAREN_HEAD',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_JODDS_UMAREN_HEAD; class=速報系; ref=code:2001; key=○; doc=12-3-49-JODDS_UMAREN_HEAD',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_JODDS_UMAREN_HEAD; class=速報系; key=○; doc=12-3-49-JODDS_UMAREN_HEAD',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_JODDS_UMAREN_HEAD; class=速報系; key=○; doc=12-3-49-JODDS_UMAREN_HEAD',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_JODDS_UMAREN_HEAD; class=速報系; key=○; doc=12-3-49-JODDS_UMAREN_HEAD',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_JODDS_UMAREN_HEAD; class=速報系; unit=mmddhhmm; key=○; doc=12-3-49-JODDS_UMAREN_HEAD; note=中間オッズのみ設定/時系列オッズ使用時キー',
  `TorokuTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=登録頭数; column=TorokuTosu; table=S_JODDS_UMAREN_HEAD; class=速報系; doc=12-3-49-JODDS_UMAREN_HEAD; desc=出馬表発表時の登録頭数',
  `SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=出走頭数; column=SyussoTosu; table=S_JODDS_UMAREN_HEAD; class=速報系; doc=12-3-49-JODDS_UMAREN_HEAD; desc=登録頭数から出走取消・競走除外・発走除外を除いた頭数',
  `UmarenFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(馬連); column=UmarenFlag; table=S_JODDS_UMAREN_HEAD; class=速報系; vals=0:発売なし 1:発売前取消 3:発売後取消 7:発売あり; doc=12-3-49-JODDS_UMAREN_HEAD',
  `TotalHyosuUmaren` varchar(11) DEFAULT NULL COMMENT '[COL] name=馬連票数合計; column=TotalHyosuUmaren; table=S_JODDS_UMAREN_HEAD; class=速報系; unit=百円; note=返還分含む; doc=12-3-49-JODDS_UMAREN_HEAD',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=時系列オッズ_馬連_ヘッダ; table=S_JODDS_UMAREN_HEAD; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
