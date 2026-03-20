-- Table structure for table `S_BANUSI`
-- Table structure for table `S_BANUSI`
--

DROP TABLE IF EXISTS `S_BANUSI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_BANUSI` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=BNでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=1新規登録/2更新/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_BANUSI; class=速報系; unit=yyyymmdd; doc=12-3-33-BANUSI; desc=西暦4桁+月日各2桁',
  `BanusiCode` varchar(6) NOT NULL COMMENT '[COL] name=馬主コード; column=BanusiCode; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; key=○',
  `BanusiName_Co` varchar(64) DEFAULT NULL COMMENT '[COL] name=馬主名(法人各有); column=BanusiName_Co; table=S_BANUSI; class=速報系; unit=全角32～半角64; doc=12-3-33-BANUSI; desc=外国馬主は欧字の先頭64バイト',
  `BanusiName` varchar(64) DEFAULT NULL COMMENT '[COL] name=馬主名(法人各無); column=BanusiName; table=S_BANUSI; class=速報系; unit=全角32～半角64; doc=12-3-33-BANUSI; desc=法人格語を除去/外国は欧字先頭64B',
  `BanusiNameKana` varchar(50) DEFAULT NULL COMMENT '[COL] name=馬主名半角ｶﾅ; column=BanusiNameKana; table=S_BANUSI; class=速報系; unit=半角50; doc=12-3-33-BANUSI; desc=半角ｶﾅ以外は設定しない(外国は空)',
  `BanusiNameEng` varchar(100) DEFAULT NULL COMMENT '[COL] name=馬主名欧字; column=BanusiNameEng; table=S_BANUSI; class=速報系; unit=全50～半100; doc=12-3-33-BANUSI; desc=特殊記号は全角で設定',
  `Fukusyoku` varchar(60) DEFAULT NULL COMMENT '[COL] name=服色標示; column=Fukusyoku; table=S_BANUSI; class=速報系; unit=全角30; doc=12-3-33-BANUSI; desc=勝負服の色・模様の表記（例: 水色,赤山形一本輪…）',
  `H_SetYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=本年成績情報_設定年; column=H_SetYear; table=S_BANUSI; class=速報系; unit=yyyy; doc=12-3-33-BANUSI',
  `H_HonSyokinTotal` varchar(10) DEFAULT NULL COMMENT '[COL] name=本年成績情報_本賞金合計; column=H_HonSyokinTotal; table=S_BANUSI; class=速報系; unit=百円; doc=12-3-33-BANUSI; desc=中央の本賞金合計',
  `H_FukaSyokin` varchar(10) DEFAULT NULL COMMENT '[COL] name=本年成績情報_付加賞金合計; column=H_FukaSyokin; table=S_BANUSI; class=速報系; unit=百円; doc=12-3-33-BANUSI; desc=中央の付加賞金合計',
  `H_ChakuKaisu1` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数1; column=H_ChakuKaisu1; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=1着の回数（中央のみ）',
  `H_ChakuKaisu2` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数2; column=H_ChakuKaisu2; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=2着の回数（中央のみ）',
  `H_ChakuKaisu3` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数3; column=H_ChakuKaisu3; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=3着の回数（中央のみ）',
  `H_ChakuKaisu4` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数4; column=H_ChakuKaisu4; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=4着の回数（中央のみ）',
  `H_ChakuKaisu5` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数5; column=H_ChakuKaisu5; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=5着の回数（中央のみ）',
  `H_ChakuKaisu6` varchar(6) DEFAULT NULL COMMENT '[COL] name=本年成績情報_着回数6; column=H_ChakuKaisu6; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=着外の回数（中央のみ）',
  `R_SetYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=累計成績情報_設定年; column=R_SetYear; table=S_BANUSI; class=速報系; unit=yyyy; doc=12-3-33-BANUSI',
  `R_HonSyokinTotal` varchar(10) DEFAULT NULL COMMENT '[COL] name=累計成績情報_本賞金合計; column=R_HonSyokinTotal; table=S_BANUSI; class=速報系; unit=百円; doc=12-3-33-BANUSI; desc=中央の本賞金合計',
  `R_FukaSyokin` varchar(10) DEFAULT NULL COMMENT '[COL] name=累計成績情報_付加賞金合計; column=R_FukaSyokin; table=S_BANUSI; class=速報系; unit=百円; doc=12-3-33-BANUSI; desc=中央の付加賞金合計',
  `R_ChakuKaisu1` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数1; column=R_ChakuKaisu1; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=1着の回数（中央のみ）',
  `R_ChakuKaisu2` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数2; column=R_ChakuKaisu2; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=2着の回数（中央のみ）',
  `R_ChakuKaisu3` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数3; column=R_ChakuKaisu3; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=3着の回数（中央のみ）',
  `R_ChakuKaisu4` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数4; column=R_ChakuKaisu4; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=4着の回数（中央のみ）',
  `R_ChakuKaisu5` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数5; column=R_ChakuKaisu5; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=5着の回数（中央のみ）',
  `R_ChakuKaisu6` varchar(6) DEFAULT NULL COMMENT '[COL] name=累計成績情報_着回数6; column=R_ChakuKaisu6; table=S_BANUSI; class=速報系; doc=12-3-33-BANUSI; desc=着外の回数（中央のみ）',
  PRIMARY KEY (`BanusiCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=馬主マスタ; table=S_BANUSI; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
