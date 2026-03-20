-- Table structure for table `N_ODDS_UMATAN`
-- Table structure for table `N_ODDS_UMATAN`
--

DROP TABLE IF EXISTS `N_ODDS_UMATAN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_ODDS_UMATAN` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_ODDS_UMATAN; class=蓄積系; unit=yyyymmdd; doc=12-3-22-ODDS_UMATAN; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_ODDS_UMATAN; class=蓄積系; unit=yyyy; doc=12-3-22-ODDS_UMATAN; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_ODDS_UMATAN; class=蓄積系; unit=mmdd; doc=12-3-22-ODDS_UMATAN; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_ODDS_UMATAN; class=蓄積系; ref=code:2001; doc=12-3-22-ODDS_UMATAN; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_ODDS_UMATAN; class=蓄積系; doc=12-3-22-ODDS_UMATAN; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_ODDS_UMATAN; class=蓄積系; doc=12-3-22-ODDS_UMATAN; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_ODDS_UMATAN; class=蓄積系; doc=12-3-22-ODDS_UMATAN; desc=該当レース番号',
  `Kumi` varchar(4) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=N_ODDS_UMATAN; class=蓄積系; doc=12-3-22-ODDS_UMATAN; desc=該当組番(4桁)',
  `Odds` varchar(6) DEFAULT NULL COMMENT '[COL] name=オッズ; column=Odds; table=N_ODDS_UMATAN; class=蓄積系; unit=倍; doc=12-3-22-ODDS_UMATAN; desc=99999.9倍で設定/2004-08-13以前は9999.9が上限/099999:9999.9倍以上/000000:無投票/------:発売前取消/******:発売後取消/スペース:登録なし',
  `Ninki` varchar(3) DEFAULT NULL COMMENT '[COL] name=人気順; column=Ninki; table=N_ODDS_UMATAN; class=蓄積系; doc=12-3-22-ODDS_UMATAN; desc=スペース:登録なし/---:発売前取消/***:発売後取消/無投票時は発売されている組合せの最大値を設定',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=オッズ_馬単; table=N_ODDS_UMATAN; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
