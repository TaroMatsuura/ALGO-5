-- Table structure for table `N_HYOSU_TANPUKU`
-- Table structure for table `N_HYOSU_TANPUKU`
--

DROP TABLE IF EXISTS `N_HYOSU_TANPUKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_HYOSU_TANPUKU` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_HYOSU_TANPUKU; class=蓄積系; unit=yyyymmdd; doc=12-3-07-HYOSU_TANPUKU; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_HYOSU_TANPUKU; class=蓄積系; unit=yyyy; doc=12-3-07-HYOSU_TANPUKU; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_HYOSU_TANPUKU; class=蓄積系; unit=mmdd; doc=12-3-07-HYOSU_TANPUKU; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_HYOSU_TANPUKU; class=蓄積系; ref=code:2001; doc=12-3-07-HYOSU_TANPUKU; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_HYOSU_TANPUKU; class=蓄積系; doc=12-3-07-HYOSU_TANPUKU; desc=同年同場の第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_HYOSU_TANPUKU; class=蓄積系; doc=12-3-07-HYOSU_TANPUKU; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_HYOSU_TANPUKU; class=蓄積系; doc=12-3-07-HYOSU_TANPUKU; desc=該当レース番号',
  `Umaban` varchar(2) NOT NULL COMMENT '[COL] name=馬番; column=Umaban; table=N_HYOSU_TANPUKU; class=蓄積系; doc=12-3-07-HYOSU_TANPUKU; desc=該当馬番',
  `TanHyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=単勝票数; column=TanHyo; table=N_HYOSU_TANPUKU; class=蓄積系; unit=百円; doc=12-3-07-HYOSU_TANPUKU; desc=単位百円/ALL0:発売前取消･票数なし/スペース:登録なし',
  `TanNinki` varchar(2) DEFAULT NULL COMMENT '[COL] name=単勝人気順; column=TanNinki; table=N_HYOSU_TANPUKU; class=蓄積系; doc=12-3-07-HYOSU_TANPUKU; desc=スペース:登録なし/"--":発売前取消/"**":発売後取消',
  `FukuHyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=複勝票数; column=FukuHyo; table=N_HYOSU_TANPUKU; class=蓄積系; unit=百円; doc=12-3-07-HYOSU_TANPUKU; desc=単位百円/ALL0:発売前取消･票数なし/スペース:登録なし',
  `FukuNinki` varchar(2) DEFAULT NULL COMMENT '[COL] name=複勝人気順; column=FukuNinki; table=N_HYOSU_TANPUKU; class=蓄積系; doc=12-3-07-HYOSU_TANPUKU; desc=スペース:登録なし/"--":発売前取消/"**":発売後取消',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Umaban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=票数_単複; table=N_HYOSU_TANPUKU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
