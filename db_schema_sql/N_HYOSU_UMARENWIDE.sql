-- Table structure for table `N_HYOSU_UMARENWIDE`
-- Table structure for table `N_HYOSU_UMARENWIDE`
--

DROP TABLE IF EXISTS `N_HYOSU_UMARENWIDE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_HYOSU_UMARENWIDE` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_HYOSU_UMARENWIDE; class=蓄積系; unit=yyyymmdd; doc=12-3-09-HYOSU_UMARENWIDE; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_HYOSU_UMARENWIDE; class=蓄積系; unit=yyyy; doc=12-3-09-HYOSU_UMARENWIDE; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_HYOSU_UMARENWIDE; class=蓄積系; unit=mmdd; doc=12-3-09-HYOSU_UMARENWIDE; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_HYOSU_UMARENWIDE; class=蓄積系; ref=code:2001; doc=12-3-09-HYOSU_UMARENWIDE; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_HYOSU_UMARENWIDE; class=蓄積系; doc=12-3-09-HYOSU_UMARENWIDE; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_HYOSU_UMARENWIDE; class=蓄積系; doc=12-3-09-HYOSU_UMARENWIDE; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_HYOSU_UMARENWIDE; class=蓄積系; doc=12-3-09-HYOSU_UMARENWIDE; desc=該当レース番号',
  `Kumi` varchar(4) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=N_HYOSU_UMARENWIDE; class=蓄積系; doc=12-3-09-HYOSU_UMARENWIDE; desc=該当組番',
  `UmarenHyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=馬連票数; column=UmarenHyo; table=N_HYOSU_UMARENWIDE; class=蓄積系; unit=百円; doc=12-3-09-HYOSU_UMARENWIDE; desc=ALL0:発売前取消･票数なし/スペース:登録なし',
  `UmarenNinki` varchar(3) DEFAULT NULL COMMENT '[COL] name=馬連人気順; column=UmarenNinki; table=N_HYOSU_UMARENWIDE; class=蓄積系; doc=12-3-09-HYOSU_UMARENWIDE; desc=スペース:登録なし/---:発売前取消/***:発売後取消',
  `WideHyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=ワイド票数; column=WideHyo; table=N_HYOSU_UMARENWIDE; class=蓄積系; unit=百円; doc=12-3-09-HYOSU_UMARENWIDE; desc=ALL0:発売前取消･票数なし/スペース:登録なし',
  `WideNinki` varchar(3) DEFAULT NULL COMMENT '[COL] name=ワイド人気順; column=WideNinki; table=N_HYOSU_UMARENWIDE; class=蓄積系; doc=12-3-09-HYOSU_UMARENWIDE; desc=スペース:登録なし/---:発売前取消/***:発売後取消',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=票数_馬連_ワイド; table=N_HYOSU_UMARENWIDE; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
