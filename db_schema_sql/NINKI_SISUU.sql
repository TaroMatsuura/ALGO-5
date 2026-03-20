-- Table structure for table `NINKI_SISUU`
-- Table structure for table `NINKI_SISUU`
--

DROP TABLE IF EXISTS `NINKI_SISUU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `NINKI_SISUU` (
  `MakeDate` varchar(8) NOT NULL DEFAULT '0' COMMENT 'データ作成年月日',
  `Year` varchar(4) NOT NULL DEFAULT '0' COMMENT '開催年',
  `MonthDay` varchar(4) NOT NULL DEFAULT '0' COMMENT '開催月日',
  `JyoCD` varchar(2) NOT NULL DEFAULT '0' COMMENT '競馬場コード',
  `Kaiji` varchar(2) NOT NULL DEFAULT '0' COMMENT '開催回[第N回]',
  `Nichiji` varchar(2) NOT NULL DEFAULT '0' COMMENT '開催日目[N日目]',
  `RaceNum` varchar(2) NOT NULL DEFAULT '0' COMMENT 'レース番号',
  `Umaban` varchar(2) NOT NULL DEFAULT '0' COMMENT '馬番',
  `Ninkisisuu` varchar(3) NOT NULL DEFAULT '0' COMMENT '人気指数',
  `Yobi` varchar(6) DEFAULT '0' COMMENT '短評',
  `KankeiDanwa` varchar(50) DEFAULT '0' COMMENT '関係者の談話',
  `DanwaDangerScore` int(11) DEFAULT 0 COMMENT '談話危険スコア',
  `DanwaTrustScore` int(11) DEFAULT 0 COMMENT '談話信頼スコア',
  PRIMARY KEY (`Year`,`MonthDay`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Umaban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=人気指数; table=NINKI_SISUU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
