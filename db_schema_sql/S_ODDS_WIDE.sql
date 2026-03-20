-- Table structure for table `S_ODDS_WIDE`
-- Table structure for table `S_ODDS_WIDE`
--

DROP TABLE IF EXISTS `S_ODDS_WIDE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_ODDS_WIDE` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_ODDS_WIDE; class=速報系; unit=yyyymmdd; doc=12-3-20-ODDS_WIDE; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_ODDS_WIDE; class=速報系; unit=yyyy; doc=12-3-20-ODDS_WIDE; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_ODDS_WIDE; class=速報系; unit=mmdd; doc=12-3-20-ODDS_WIDE; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_ODDS_WIDE; class=速報系; ref=code:2001; doc=12-3-20-ODDS_WIDE; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_ODDS_WIDE; class=速報系; doc=12-3-20-ODDS_WIDE; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_ODDS_WIDE; class=速報系; doc=12-3-20-ODDS_WIDE; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_ODDS_WIDE; class=速報系; doc=12-3-20-ODDS_WIDE; desc=該当レース番号',
  `Kumi` varchar(4) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=S_ODDS_WIDE; class=速報系; doc=12-3-20-ODDS_WIDE; desc=該当組番',
  `OddsLow` varchar(5) DEFAULT NULL COMMENT '[COL] name=最低オッズ; column=OddsLow; table=S_ODDS_WIDE; class=速報系; unit=倍; doc=12-3-20-ODDS_WIDE; desc=9999.9倍で設定/99999:9999.9倍以上/00000:無投票/-----:発売前取消/*****:発売後取消/スペース:登録なし',
  `OddsHigh` varchar(5) DEFAULT NULL COMMENT '[COL] name=最高オッズ; column=OddsHigh; table=S_ODDS_WIDE; class=速報系; unit=倍; doc=12-3-20-ODDS_WIDE; desc=9999.9倍で設定/99999:9999.9倍以上/00000:無投票/-----:発売前取消/*****:発売後取消/スペース:登録なし',
  `Ninki` varchar(3) DEFAULT NULL COMMENT '[COL] name=人気順; column=Ninki; table=S_ODDS_WIDE; class=速報系; doc=12-3-20-ODDS_WIDE; desc=スペース:登録なし/---:発売前取消/***:発売後取消/無投票時は発売されている組合せの最大値を設定',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=オッズ_ワイド; table=S_ODDS_WIDE; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
