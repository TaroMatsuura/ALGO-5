-- Table structure for table `N_BAMEIORIGIN`
-- Table structure for table `N_BAMEIORIGIN`
--

DROP TABLE IF EXISTS `N_BAMEIORIGIN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_BAMEIORIGIN` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_BAMEIORIGIN; class=蓄積系; doc=12-3-52-BAMEIORIGIN; desc=HYでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_BAMEIORIGIN; class=蓄積系; doc=12-3-52-BAMEIORIGIN; vals=1:初期値 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_BAMEIORIGIN; class=蓄積系; unit=yyyymmdd; doc=12-3-52-BAMEIORIGIN',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=N_BAMEIORIGIN; class=蓄積系; key=○; doc=12-3-52-BAMEIORIGIN; link=競走馬マスタ',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=N_BAMEIORIGIN; class=蓄積系; unit=全角18; doc=12-3-52-BAMEIORIGIN',
  `Origin` varchar(64) DEFAULT NULL COMMENT '[COL] name=馬名の意味由来; column=Origin; table=N_BAMEIORIGIN; class=蓄積系; unit=全角32; doc=12-3-52-BAMEIORIGIN',
  PRIMARY KEY (`KettoNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=馬名の意味由来; table=N_BAMEIORIGIN; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
