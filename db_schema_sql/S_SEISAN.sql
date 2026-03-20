-- Table structure for table `S_SEISAN`
-- Table structure for table `S_SEISAN`
--

DROP TABLE IF EXISTS `S_SEISAN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_SEISAN` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=BRでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=1新規登録/2更新/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_SEISAN; class=速報系; unit=yyyymmdd; doc=12-3-32-SEISAN; desc=西暦4桁+月日各2桁',
  `BreederCode` varchar(8) NOT NULL COMMENT '[COL] name=生産者コード; column=BreederCode; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; key=○',
  `BreederName_Co` varchar(72) DEFAULT NULL COMMENT '[COL] name=生産者名(法人各有); column=BreederName_Co; table=S_SEISAN; class=速報系; unit=全角35～半角72; doc=12-3-32-SEISAN; desc=外国生産者は欧字の先頭72バイト',
  `BreederName` varchar(72) DEFAULT NULL COMMENT '[COL] name=生産者名(法人各無); column=BreederName; table=S_SEISAN; class=速報系; unit=全角35～半角72; doc=12-3-32-SEISAN; desc=法人格語の除去/外国は欧字先頭72B',
  `BreederNameKana` varchar(72) DEFAULT NULL COMMENT '[COL] name=生産者名半角ｶﾅ; column=BreederNameKana; table=S_SEISAN; class=速報系; unit=半角70; doc=12-3-32-SEISAN; desc=半角ｶﾅ以外は設定しない(外国は空)',
  `BreederNameEng` varchar(168) DEFAULT NULL COMMENT '[COL] name=生産者名欧字; column=BreederNameEng; table=S_SEISAN; class=速報系; unit=全84～半168; doc=12-3-32-SEISAN; desc=特殊記号は全角で設定',
  `Address` varchar(20) DEFAULT NULL COMMENT '[COL] name=生産者住所自治省名; column=Address; table=S_SEISAN; class=速報系; unit=全角10; doc=12-3-32-SEISAN; desc=生産者の所在地',
  `H_SetYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=本年成績情報_設定年; column=H_SetYear; table=S_SEISAN; class=速報系; unit=yyyy; doc=12-3-32-SEISAN; desc=成績情報の年(西暦)',
  `H_HonSyokinTotal` varchar(10) DEFAULT NULL COMMENT '[COL] name=本年成績情報_本賞金合計; column=H_HonSyokinTotal; table=S_SEISAN; class=速報系; unit=百円; doc=12-3-32-SEISAN; desc=中央の本賞金合計',
  `H_FukaSyokin` varchar(10) DEFAULT NULL COMMENT '[COL] name=本年成績情報_付加賞金合計; column=H_FukaSyokin; table=S_SEISAN; class=速報系; unit=百円; doc=12-3-32-SEISAN; desc=中央の付加賞金合計',
  `H_ChakuKaisu1` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数1; column=H_ChakuKaisu1; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=1着の回数（中央のみ）',
  `H_ChakuKaisu2` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数2; column=H_ChakuKaisu2; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=2着の回数（中央のみ）',
  `H_ChakuKaisu3` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数3; column=H_ChakuKaisu3; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=3着の回数（中央のみ）',
  `H_ChakuKaisu4` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数4; column=H_ChakuKaisu4; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=4着の回数（中央のみ）',
  `H_ChakuKaisu5` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数5; column=H_ChakuKaisu5; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=5着の回数（中央のみ）',
  `H_ChakuKaisu6` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数6; column=H_ChakuKaisu6; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=着外の回数（中央のみ）',
  `R_SetYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=累計成績情報_設定年; column=R_SetYear; table=S_SEISAN; class=速報系; unit=yyyy; doc=12-3-32-SEISAN; desc=成績情報の年(西暦)',
  `R_HonSyokinTotal` varchar(10) DEFAULT NULL COMMENT '[COL] name=累計成績情報_本賞金合計; column=R_HonSyokinTotal; table=S_SEISAN; class=速報系; unit=百円; doc=12-3-32-SEISAN; desc=中央の本賞金合計',
  `R_FukaSyokin` varchar(10) DEFAULT NULL COMMENT '[COL] name=累計成績情報_付加賞金合計; column=R_FukaSyokin; table=S_SEISAN; class=速報系; unit=百円; doc=12-3-32-SEISAN; desc=中央の付加賞金合計',
  `R_ChakuKaisu1` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数1; column=R_ChakuKaisu1; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=1着の回数（中央のみ）',
  `R_ChakuKaisu2` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数2; column=R_ChakuKaisu2; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=2着の回数（中央のみ）',
  `R_ChakuKaisu3` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数3; column=R_ChakuKaisu3; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=3着の回数（中央のみ）',
  `R_ChakuKaisu4` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数4; column=R_ChakuKaisu4; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=4着の回数（中央のみ）',
  `R_ChakuKaisu5` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数5; column=R_ChakuKaisu5; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=5着の回数（中央のみ）',
  `R_ChakuKaisu6` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数6; column=R_ChakuKaisu6; table=S_SEISAN; class=速報系; doc=12-3-32-SEISAN; desc=着外の回数（中央のみ）',
  PRIMARY KEY (`BreederCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=生産者マスタ; table=S_SEISAN; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
