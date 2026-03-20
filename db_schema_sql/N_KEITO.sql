-- Table structure for table `N_KEITO`
-- Table structure for table `N_KEITO`
--

DROP TABLE IF EXISTS `N_KEITO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_KEITO` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_KEITO; class=蓄積系; doc=12-3-53-KEITO; desc=BTでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_KEITO; class=蓄積系; doc=12-3-53-KEITO; vals=1:新規登録 2:更新 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_KEITO; class=蓄積系; unit=yyyymmdd; doc=12-3-53-KEITO',
  `HansyokuNum` varchar(10) NOT NULL COMMENT '[COL] name=繁殖登録番号; column=HansyokuNum; table=N_KEITO; class=蓄積系; key=○; doc=12-3-53-KEITO',
  `KeitoId` varchar(30) DEFAULT NULL COMMENT '[COL] name=系統ID; column=KeitoId; table=N_KEITO; class=蓄積系; doc=12-3-53-KEITO; desc=2桁ごとに系譜を表現するID(JV-DATA仕様参照)',
  `KeitoName` varchar(36) DEFAULT NULL COMMENT '[COL] name=系統名; column=KeitoName; table=N_KEITO; class=蓄積系; doc=12-3-53-KEITO; desc=サンデーサイレンス系等の名称',
  `KeitoEx` varchar(6800) DEFAULT NULL COMMENT '[COL] name=系統説明; column=KeitoEx; table=N_KEITO; class=蓄積系; doc=12-3-53-KEITO; unit=テキスト文',
  PRIMARY KEY (`HansyokuNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=系統情報; table=N_KEITO; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
