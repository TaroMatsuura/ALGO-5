-- Table structure for table `N_JODDS_TANPUKU`
-- Table structure for table `N_JODDS_TANPUKU`
--

DROP TABLE IF EXISTS `N_JODDS_TANPUKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_JODDS_TANPUKU` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_JODDS_TANPUKU; class=蓄積系; unit=yyyymmdd; doc=12-3-47-JODDS_TANPUKU; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_JODDS_TANPUKU; class=蓄積系; unit=yyyy; key=○; doc=12-3-47-JODDS_TANPUKU',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_JODDS_TANPUKU; class=蓄積系; unit=mmdd; key=○; doc=12-3-47-JODDS_TANPUKU',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_JODDS_TANPUKU; class=蓄積系; ref=code:2001; key=○; doc=12-3-47-JODDS_TANPUKU',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_JODDS_TANPUKU; class=蓄積系; key=○; doc=12-3-47-JODDS_TANPUKU',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_JODDS_TANPUKU; class=蓄積系; key=○; doc=12-3-47-JODDS_TANPUKU',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_JODDS_TANPUKU; class=蓄積系; key=○; doc=12-3-47-JODDS_TANPUKU',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=N_JODDS_TANPUKU; class=蓄積系; unit=mmddhhmm; key=○; doc=12-3-47-JODDS_TANPUKU; note=中間オッズのみ設定/時系列オッズ使用時キー',
  `Umaban` varchar(2) NOT NULL COMMENT '[COL] name=馬番; column=Umaban; table=N_JODDS_TANPUKU; class=蓄積系; key=○; doc=12-3-47-JODDS_TANPUKU; desc=該当馬番(01～18)',
  `TanOdds` varchar(4) DEFAULT NULL COMMENT '[COL] name=単勝オッズ; column=TanOdds; table=N_JODDS_TANPUKU; class=蓄積系; format=999.9倍; doc=12-3-47-JODDS_TANPUKU; special="9999":999.9倍以上/"0000":無投票/"----":発売前取消/"****":発売後取消/" ":登録なし',
  `TanNinki` varchar(2) DEFAULT NULL COMMENT '[COL] name=単勝人気順; column=TanNinki; table=N_JODDS_TANPUKU; class=蓄積系; doc=12-3-47-JODDS_TANPUKU; special=" ":登録なし/"--":発売前取消/"**":発売後取消; note=無投票時は発売組合せの最大値を設定',
  `FukuOddsLow` varchar(4) DEFAULT NULL COMMENT '[COL] name=複勝最低オッズ; column=FukuOddsLow; table=N_JODDS_TANPUKU; class=蓄積系; format=999.9倍; doc=12-3-47-JODDS_TANPUKU; special="0999":99.9倍以上/"0000":無投票/"----":発売前取消/"****":発売後取消/" ":登録なし; note=2004-08-13以前は99.9倍が上限',
  `FukuOddsHigh` varchar(4) DEFAULT NULL COMMENT '[COL] name=複勝最高オッズ; column=FukuOddsHigh; table=N_JODDS_TANPUKU; class=蓄積系; format=999.9倍; doc=12-3-47-JODDS_TANPUKU; special="0999":99.9倍以上/"0000":無投票/"----":発売前取消/"****":発売後取消/" ":登録なし; note=2004-08-13以前は99.9倍が上限',
  `FukuNinki` varchar(2) DEFAULT NULL COMMENT '[COL] name=複勝人気順; column=FukuNinki; table=N_JODDS_TANPUKU; class=蓄積系; doc=12-3-47-JODDS_TANPUKU; special=" ":登録なし/"--":発売前取消/"**":発売後取消; note=無投票時は発売組合せの最大値を設定',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`,`Umaban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=時系列オッズ_単複; table=N_JODDS_TANPUKU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
