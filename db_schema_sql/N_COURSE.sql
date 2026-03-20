-- Table structure for table `N_COURSE`
-- Table structure for table `N_COURSE`
--

DROP TABLE IF EXISTS `N_COURSE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_COURSE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_COURSE; class=蓄積系; doc=12-3-54-COURSE; desc=CSでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_COURSE; class=蓄積系; doc=12-3-54-COURSE; vals=1:新規登録 2:更新 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_COURSE; class=蓄積系; unit=yyyymmdd; doc=12-3-54-COURSE',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_COURSE; class=蓄積系; ref=code:2001; key=○; doc=12-3-54-COURSE',
  `Kyori` varchar(4) NOT NULL COMMENT '[COL] name=距離; column=Kyori; table=N_COURSE; class=蓄積系; unit=m; key=○; doc=12-3-54-COURSE',
  `TrackCD` varchar(2) NOT NULL COMMENT '[COL] name=トラックコード; column=TrackCD; table=N_COURSE; class=蓄積系; ref=code:2009; key=○; doc=12-3-54-COURSE',
  `KaishuDate` varchar(8) NOT NULL COMMENT '[COL] name=コース改修年月日; column=KaishuDate; table=N_COURSE; class=蓄積系; unit=yyyymmdd; key=○; doc=12-3-54-COURSE; desc=コース改修後、最初に行われた開催日',
  `CourseEX` varchar(6800) DEFAULT NULL COMMENT '[COL] name=コース説明; column=CourseEX; table=N_COURSE; class=蓄積系; unit=テキスト文; doc=12-3-54-COURSE',
  PRIMARY KEY (`JyoCD`,`Kyori`,`TrackCD`,`KaishuDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=コース情報; table=N_COURSE; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
