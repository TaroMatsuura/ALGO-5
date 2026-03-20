-- Table structure for table `N_TOKU`
-- Table structure for table `N_TOKU`
--

DROP TABLE IF EXISTS `N_TOKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_TOKU` (
  `MakeDate` varchar(8) DEFAULT NULL,
  `Year` varchar(4) NOT NULL,
  `MonthDay` varchar(4) NOT NULL,
  `JyoCD` varchar(2) NOT NULL,
  `Kaiji` varchar(2) NOT NULL,
  `Nichiji` varchar(2) NOT NULL,
  `RaceNum` varchar(2) NOT NULL,
  `Num` varchar(3) NOT NULL,
  `KettoNum` varchar(10) DEFAULT NULL,
  `Bamei` varchar(36) DEFAULT NULL,
  `UmaKigoCD` varchar(2) DEFAULT NULL,
  `SexCD` varchar(1) DEFAULT NULL,
  `TozaiCD` varchar(1) DEFAULT NULL,
  `ChokyosiCode` varchar(5) DEFAULT NULL,
  `ChokyosiRyakusyo` varchar(8) DEFAULT NULL,
  `Futan` varchar(3) DEFAULT NULL,
  `Koryu` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`Year`,`MonthDay`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
