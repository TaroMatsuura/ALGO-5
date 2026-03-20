-- Table structure for table `N_JODDS_WAKU`
-- Table structure for table `N_JODDS_WAKU`
--

DROP TABLE IF EXISTS `N_JODDS_WAKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_JODDS_WAKU` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_JODDS_WAKU; class=蓄積系; unit=yyyymmdd; doc=12-3-48-JODDS_WAKU; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_JODDS_WAKU; class=蓄積系; unit=yyyy; key=○; doc=12-3-48-JODDS_WAKU',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_JODDS_WAKU; class=蓄積系; unit=mmdd; key=○; doc=12-3-48-JODDS_WAKU',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_JODDS_WAKU; class=蓄積系; ref=code:2001; key=○; doc=12-3-48-JODDS_WAKU',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_JODDS_WAKU; class=蓄積系; key=○; doc=12-3-48-JODDS_WAKU',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_JODDS_WAKU; class=蓄積系; key=○; doc=12-3-48-JODDS_WAKU',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_JODDS_WAKU; class=蓄積系; key=○; doc=12-3-48-JODDS_WAKU',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=N_JODDS_WAKU; class=蓄積系; unit=mmddhhmm; key=○; doc=12-3-48-JODDS_WAKU; note=中間オッズのみ設定/時系列キー',
  `Kumi` varchar(2) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=N_JODDS_WAKU; class=蓄積系; key=○; doc=12-3-48-JODDS_WAKU; desc=01～08の組合せ2桁(例: 18, 27)',
  `Odds` varchar(5) DEFAULT NULL COMMENT '[COL] name=オッズ; column=Odds; table=N_JODDS_WAKU; class=蓄積系; format=9999.9倍; doc=12-3-48-JODDS_WAKU; special="09999":999.9倍以上/"00000":無投票/"-----":発売前取消/"*****":発売後取消/" ":登録なし; note=2004-08-13以前は999.9倍が上限',
  `Ninki` varchar(2) DEFAULT NULL COMMENT '[COL] name=人気順; column=Ninki; table=N_JODDS_WAKU; class=蓄積系; doc=12-3-48-JODDS_WAKU; special=" ":登録なし/"--":発売前取消/"**":発売後取消; note=無投票時は発売されている組合せの最大値を設定',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=時系列オッズ_枠連; table=N_JODDS_WAKU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
