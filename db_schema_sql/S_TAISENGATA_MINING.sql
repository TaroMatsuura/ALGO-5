-- Table structure for table `S_TAISENGATA_MINING`
-- Table structure for table `S_TAISENGATA_MINING`
--

DROP TABLE IF EXISTS `S_TAISENGATA_MINING`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_TAISENGATA_MINING` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=TMでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; vals=1:前日予想(出馬発表後) 2:当日予想(天候馬場発表後) 3:直前予想(馬体重発表後) 7:成績(月曜)[蓄積系のみ] 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_TAISENGATA_MINING; class=速報系; unit=yyyymmdd; doc=12-3-55-TAISENGATA_MINING',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_TAISENGATA_MINING; class=速報系; unit=yyyy; key=○; doc=12-3-55-TAISENGATA_MINING',
  `MonthDay` varchar(4) NOT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_TAISENGATA_MINING; class=速報系; unit=mmdd; key=○; doc=12-3-55-TAISENGATA_MINING',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_TAISENGATA_MINING; class=速報系; ref=code:2001; key=○; doc=12-3-55-TAISENGATA_MINING',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_TAISENGATA_MINING; class=速報系; key=○; doc=12-3-55-TAISENGATA_MINING',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_TAISENGATA_MINING; class=速報系; key=○; doc=12-3-55-TAISENGATA_MINING',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_TAISENGATA_MINING; class=速報系; key=○; doc=12-3-55-TAISENGATA_MINING',
  `MakeHM` varchar(4) DEFAULT NULL COMMENT '[COL] name=データ作成時分; column=MakeHM; table=S_TAISENGATA_MINING; class=速報系; unit=hhmm; doc=12-3-55-TAISENGATA_MINING; desc=時分各2桁',
  `Umaban1` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番1; column=Umaban1; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore1` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア1; column=TMScore1; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban2` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番2; column=Umaban2; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore2` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア2; column=TMScore2; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban3` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番3; column=Umaban3; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore3` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア3; column=TMScore3; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban4` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番4; column=Umaban4; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore4` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア4; column=TMScore4; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban5` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番5; column=Umaban5; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore5` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア5; column=TMScore5; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban6` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番6; column=Umaban6; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore6` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア6; column=TMScore6; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban7` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番7; column=Umaban7; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore7` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア7; column=TMScore7; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban8` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番8; column=Umaban8; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore8` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア8; column=TMScore8; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban9` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番9; column=Umaban9; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore9` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア9; column=TMScore9; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban10` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番10; column=Umaban10; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore10` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア10; column=TMScore10; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban11` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番11; column=Umaban11; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore11` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア11; column=TMScore11; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban12` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番12; column=Umaban12; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore12` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア12; column=TMScore12; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban13` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番13; column=Umaban13; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore13` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア13; column=TMScore13; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban14` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番14; column=Umaban14; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore14` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア14; column=TMScore14; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban15` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番15; column=Umaban15; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore15` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア15; column=TMScore15; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban16` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番16; column=Umaban16; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore16` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア16; column=TMScore16; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban17` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番17; column=Umaban17; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore17` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア17; column=TMScore17; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  `Umaban18` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番18; column=Umaban18; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; desc=該当馬番01～18',
  `TMScore18` varchar(4) DEFAULT NULL COMMENT '[COL] name=予測スコア18; column=TMScore18; table=S_TAISENGATA_MINING; class=速報系; doc=12-3-55-TAISENGATA_MINING; format=000.0-100.0; decimal=1; desc=右端1桁が小数第1位',
  PRIMARY KEY (`Year`,`MonthDay`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=対戦型データマイニング予想; table=S_TAISENGATA_MINING; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
