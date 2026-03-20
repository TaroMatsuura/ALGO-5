-- Table structure for table `S_ODDS_TANPUKU`
-- Table structure for table `S_ODDS_TANPUKU`
--

DROP TABLE IF EXISTS `S_ODDS_TANPUKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_ODDS_TANPUKU` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_ODDS_TANPUKU; class=速報系; unit=yyyymmdd; doc=12-3-15-ODDS_TANPUKU; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_ODDS_TANPUKU; class=速報系; unit=yyyy; doc=12-3-15-ODDS_TANPUKU; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_ODDS_TANPUKU; class=速報系; unit=mmdd; doc=12-3-15-ODDS_TANPUKU; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_ODDS_TANPUKU; class=速報系; ref=code:2001; doc=12-3-15-ODDS_TANPUKU; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_ODDS_TANPUKU; class=速報系; doc=12-3-15-ODDS_TANPUKU; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_ODDS_TANPUKU; class=速報系; doc=12-3-15-ODDS_TANPUKU; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_ODDS_TANPUKU; class=速報系; doc=12-3-15-ODDS_TANPUKU; desc=該当レース番号',
  `Umaban` varchar(2) NOT NULL COMMENT '[COL] name=馬番; column=Umaban; table=S_ODDS_TANPUKU; class=速報系; doc=12-3-15-ODDS_TANPUKU; desc=該当馬番',
  `TanOdds` varchar(4) DEFAULT NULL COMMENT '[COL] name=単勝オッズ; column=TanOdds; table=S_ODDS_TANPUKU; class=速報系; unit=倍; doc=12-3-15-ODDS_TANPUKU; desc=999.9倍で設定/9999:999.9倍以上/0000:無投票/----:発売前取消/****:発売後取消/スペース:登録なし',
  `TanNinki` varchar(2) DEFAULT NULL COMMENT '[COL] name=単勝人気順; column=TanNinki; table=S_ODDS_TANPUKU; class=速報系; doc=12-3-15-ODDS_TANPUKU; desc=スペース:登録なし/--:発売前取消/**:発売後取消/無投票時は発売されている組合せの最大値を設定',
  `FukuOddsLow` varchar(4) DEFAULT NULL COMMENT '[COL] name=複勝最低オッズ; column=FukuOddsLow; table=S_ODDS_TANPUKU; class=速報系; unit=倍; doc=12-3-15-ODDS_TANPUKU; desc=999.9倍で設定(2004-08-13以前は99.9倍が最高)/0999:99.9倍以上/0000:無投票/----:発売前取消/****:発売後取消/スペース:登録なし',
  `FukuOddsHigh` varchar(4) DEFAULT NULL COMMENT '[COL] name=複勝最高オッズ; column=FukuOddsHigh; table=S_ODDS_TANPUKU; class=速報系; unit=倍; doc=12-3-15-ODDS_TANPUKU; desc=999.9倍で設定(2004-08-13以前は99.9倍が最高)/0999:99.9倍以上/0000:無投票/----:発売前取消/****:発売後取消/スペース:登録なし',
  `FukuNinki` varchar(2) DEFAULT NULL COMMENT '[COL] name=複勝人気順; column=FukuNinki; table=S_ODDS_TANPUKU; class=速報系; doc=12-3-15-ODDS_TANPUKU; desc=スペース:登録なし/--:発売前取消/**:発売後取消/無投票時は発売されている組合せの最大値を設定',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Umaban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=オッズ_単複; table=S_ODDS_TANPUKU; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
