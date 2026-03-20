-- Table structure for table `N_JYUSYOSIKI`
-- Table structure for table `N_JYUSYOSIKI`
--

DROP TABLE IF EXISTS `N_JYUSYOSIKI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_JYUSYOSIKI` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_JYUSYOSIKI; class=蓄積系; unit=yyyymmdd; doc=12-3-57-JYUSYOSIKI; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_JYUSYOSIKI; class=蓄積系; unit=yyyy; key=○; doc=12-3-57-JYUSYOSIKI',
  `MonthDay` varchar(4) NOT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_JYUSYOSIKI; class=蓄積系; unit=mmdd; key=○; doc=12-3-57-JYUSYOSIKI',
  `Kumi` varchar(10) NOT NULL COMMENT '[COL] name=組番; column=Kumi; table=N_JYUSYOSIKI; class=蓄積系; key=○; doc=12-3-57-JYUSYOSIKI; desc=重勝式的中馬番組合（的中無の場合も設定）',
  `PayJyushosiki` varchar(9) DEFAULT NULL COMMENT '[COL] name=重勝式払戻金; column=PayJyushosiki; table=N_JYUSYOSIKI; class=蓄積系; unit=円; doc=12-3-57-JYUSYOSIKI; special=的中無:000000000',
  `TekichuHyo` varchar(10) DEFAULT NULL COMMENT '[COL] name=的中票数; column=TekichuHyo; table=N_JYUSYOSIKI; class=蓄積系; unit=票; doc=12-3-57-JYUSYOSIKI; special=的中無:0000000000',
  PRIMARY KEY (`Year`,`MonthDay`,`Kumi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=重勝式; table=N_JYUSYOSIKI; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
