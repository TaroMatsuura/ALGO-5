-- Table structure for table `N_HYOSU_WAKU`
-- Table structure for table `N_HYOSU_WAKU`
--

DROP TABLE IF EXISTS `N_HYOSU_WAKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_HYOSU_WAKU` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_HYOSU_WAKU; class=蓄積系; unit=yyyymmdd; doc=12-3-08-HYOSU_WAKU; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_HYOSU_WAKU; class=蓄積系; unit=yyyy; doc=12-3-08-HYOSU_WAKU; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_HYOSU_WAKU; class=蓄積系; unit=mmdd; doc=12-3-08-HYOSU_WAKU; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_HYOSU_WAKU; class=蓄積系; ref=code:2001; doc=12-3-08-HYOSU_WAKU; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_HYOSU_WAKU; class=蓄積系; doc=12-3-08-HYOSU_WAKU; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_HYOSU_WAKU; class=蓄積系; doc=12-3-08-HYOSU_WAKU; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_HYOSU_WAKU; class=蓄積系; doc=12-3-08-HYOSU_WAKU; desc=該当レース番号',
  `Kumi` varchar(2) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=N_HYOSU_WAKU; class=蓄積系; doc=12-3-08-HYOSU_WAKU; desc=該当枠番(組)',
  `Hyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=票数; column=Hyo; table=N_HYOSU_WAKU; class=蓄積系; unit=百円; doc=12-3-08-HYOSU_WAKU; desc=ALL0:発売前取消･票数なし/スペース:登録なし',
  `Ninki` varchar(2) DEFAULT NULL COMMENT '[COL] name=人気順; column=Ninki; table=N_HYOSU_WAKU; class=蓄積系; doc=12-3-08-HYOSU_WAKU; desc=スペース:登録なし/---:発売前取消/***:発売後取消',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=票数_枠連; table=N_HYOSU_WAKU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
