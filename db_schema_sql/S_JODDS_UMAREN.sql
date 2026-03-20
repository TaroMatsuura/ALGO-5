-- Table structure for table `S_JODDS_UMAREN`
-- Table structure for table `S_JODDS_UMAREN`
--

DROP TABLE IF EXISTS `S_JODDS_UMAREN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_JODDS_UMAREN` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_JODDS_UMAREN; class=速報系; unit=yyyymmdd; doc=12-3-50-JODDS_UMAREN; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_JODDS_UMAREN; class=速報系; unit=yyyy; key=○; doc=12-3-50-JODDS_UMAREN',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_JODDS_UMAREN; class=速報系; unit=mmdd; key=○; doc=12-3-50-JODDS_UMAREN',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_JODDS_UMAREN; class=速報系; ref=code:2001; key=○; doc=12-3-50-JODDS_UMAREN',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_JODDS_UMAREN; class=速報系; key=○; doc=12-3-50-JODDS_UMAREN; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_JODDS_UMAREN; class=速報系; key=○; doc=12-3-50-JODDS_UMAREN; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_JODDS_UMAREN; class=速報系; key=○; doc=12-3-50-JODDS_UMAREN',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_JODDS_UMAREN; class=速報系; unit=mmddhhmm; key=○; doc=12-3-50-JODDS_UMAREN; note=中間オッズのみ設定/時系列オッズ使用時キー',
  `Kumi` varchar(4) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=S_JODDS_UMAREN; class=速報系; key=○; doc=12-3-50-JODDS_UMAREN; desc=該当組番',
  `Odds` varchar(6) DEFAULT NULL COMMENT '[COL] name=オッズ; column=Odds; table=S_JODDS_UMAREN; class=速報系; format=99999.9倍; doc=12-3-50-JODDS_UMAREN; special="099999":9999.9倍以上/"000000":無投票/"------":発売前取消/"******":発売後取消/" ":登録なし; note=2004-08-13以前は9999.9倍が上限',
  `Ninki` varchar(3) DEFAULT NULL COMMENT '[COL] name=人気順; column=Ninki; table=S_JODDS_UMAREN; class=速報系; doc=12-3-50-JODDS_UMAREN; special=" ":登録なし/"---":発売前取消/"***":発売後取消; note=無投票時は発売されている組合せの最大値を設定',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=時系列オッズ_馬連; table=S_JODDS_UMAREN; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
