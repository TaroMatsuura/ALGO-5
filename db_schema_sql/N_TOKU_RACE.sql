-- Table structure for table `N_TOKU_RACE`
-- Table structure for table `N_TOKU_RACE`
--

DROP TABLE IF EXISTS `N_TOKU_RACE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_TOKU_RACE` (
  `RecordSpec` varchar(2) DEFAULT NULL,
  `DataKubun` varchar(1) DEFAULT NULL,
  `MakeDate` varchar(8) DEFAULT NULL,
  `Year` varchar(4) NOT NULL,
  `MonthDay` varchar(4) NOT NULL,
  `JyoCD` varchar(2) NOT NULL,
  `Kaiji` varchar(2) NOT NULL,
  `Nichiji` varchar(2) NOT NULL,
  `RaceNum` varchar(2) NOT NULL,
  `YoubiCD` varchar(1) DEFAULT NULL,
  `TokuNum` varchar(4) DEFAULT NULL,
  `Hondai` varchar(60) DEFAULT NULL,
  `Fukudai` varchar(60) DEFAULT NULL,
  `Kakko` varchar(60) DEFAULT NULL,
  `HondaiEng` varchar(120) DEFAULT NULL,
  `FukudaiEng` varchar(120) DEFAULT NULL,
  `KakkoEng` varchar(120) DEFAULT NULL,
  `Ryakusyo10` varchar(20) DEFAULT NULL,
  `Ryakusyo6` varchar(12) DEFAULT NULL,
  `Ryakusyo3` varchar(6) DEFAULT NULL,
  `Kubun` varchar(1) DEFAULT NULL,
  `Nkai` varchar(3) DEFAULT NULL,
  `GradeCD` varchar(1) DEFAULT NULL,
  `SyubetuCD` varchar(2) DEFAULT NULL,
  `KigoCD` varchar(3) DEFAULT NULL,
  `JyuryoCD` varchar(1) DEFAULT NULL,
  `JyokenCD1` varchar(3) DEFAULT NULL,
  `JyokenCD2` varchar(3) DEFAULT NULL,
  `JyokenCD3` varchar(3) DEFAULT NULL,
  `JyokenCD4` varchar(3) DEFAULT NULL,
  `JyokenCD5` varchar(3) DEFAULT NULL,
  `Kyori` varchar(4) DEFAULT NULL,
  `TrackCD` varchar(2) DEFAULT NULL,
  `CourseKubunCD` varchar(2) DEFAULT NULL,
  `HandiDate` varchar(8) DEFAULT NULL,
  `TorokuTosu` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`Year`,`MonthDay`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
