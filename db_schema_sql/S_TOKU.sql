-- Table structure for table `S_TOKU`
-- Table structure for table `S_TOKU`
--

DROP TABLE IF EXISTS `S_TOKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_TOKU` (
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_TOKU; class=速報系; unit=yyyymmdd; doc=12-3-02-TOKU; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_TOKU; class=速報系; unit=yyyy; doc=12-3-02-TOKU; desc=該当年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_TOKU; class=速報系; unit=mmdd; doc=12-3-02-TOKU; desc=該当月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_TOKU; class=速報系; ref=code:2001; doc=12-3-02-TOKU; desc=施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=同年同場での開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=該当レース番号',
  `Num` varchar(3) NOT NULL COMMENT '[COL] name=連番; column=Num; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=1～300の連番',
  `KettoNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=S_TOKU; class=速報系; ref=code:2201; doc=12-3-02-TOKU; desc=西暦4桁+品種1桁+数字5桁',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=全角18字まで',
  `UmaKigoCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬記号コード; column=UmaKigoCD; table=S_TOKU; class=速報系; ref=code:2204; doc=12-3-02-TOKU; desc=記号コード',
  `SexCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード; column=SexCD; table=S_TOKU; class=速報系; ref=code:2202; doc=12-3-02-TOKU; desc=性別コード',
  `TozaiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=調教師東西所属コード; column=TozaiCD; table=S_TOKU; class=速報系; ref=code:2301; doc=12-3-02-TOKU; desc=東西所属コード',
  `ChokyosiCode` varchar(5) DEFAULT NULL COMMENT '[COL] name=調教師コード; column=ChokyosiCode; table=S_TOKU; class=速報系; ref=N_CHOKYO(ChokyosiCode); doc=12-3-02-TOKU; desc=調教師マスタ参照',
  `ChokyosiRyakusyo` varchar(8) DEFAULT NULL COMMENT '[COL] name=調教師名略称; column=ChokyosiRyakusyo; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=全角4字略称',
  `Futan` varchar(3) DEFAULT NULL COMMENT '[COL] name=負担重量; column=Futan; table=S_TOKU; class=速報系; unit=0.1kg; doc=12-3-02-TOKU; desc=ハンデは月曜以降に設定',
  `Koryu` varchar(1) DEFAULT NULL COMMENT '[COL] name=交流区分; column=Koryu; table=S_TOKU; class=速報系; doc=12-3-02-TOKU; desc=0初期値/1地方馬/2外国馬',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=特別登録馬; table=S_TOKU; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
