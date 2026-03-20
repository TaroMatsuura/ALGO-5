-- Table structure for table `S_CHOKYO`
-- Table structure for table `S_CHOKYO`
--

DROP TABLE IF EXISTS `S_CHOKYO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_CHOKYO` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=CHでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=1新規登録/2更新/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_CHOKYO; class=速報系; unit=yyyymmdd; doc=12-3-30-CHOKYO; desc=西暦4桁+月日各2桁',
  `ChokyosiCode` varchar(5) NOT NULL COMMENT '[COL] name=調教師コード; column=ChokyosiCode; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; key=○',
  `DelKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=調教師抹消区分; column=DelKubun; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=0現役/1抹消',
  `IssueDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=調教師免許交付年月日; column=IssueDate; table=S_CHOKYO; class=速報系; unit=yyyymmdd; doc=12-3-30-CHOKYO',
  `DelDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=調教師免許抹消年月日; column=DelDate; table=S_CHOKYO; class=速報系; unit=yyyymmdd; doc=12-3-30-CHOKYO',
  `BirthDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=生年月日; column=BirthDate; table=S_CHOKYO; class=速報系; unit=yyyymmdd; doc=12-3-30-CHOKYO',
  `ChokyosiName` varchar(34) DEFAULT NULL COMMENT '[COL] name=調教師名; column=ChokyosiName; table=S_CHOKYO; class=速報系; unit=全角17; doc=12-3-30-CHOKYO; desc=姓+全角空白1+名（外国人は連続17）',
  `ChokyosiNameKana` varchar(30) DEFAULT NULL COMMENT '[COL] name=調教師名半角ｶﾅ; column=ChokyosiNameKana; table=S_CHOKYO; class=速報系; unit=半角30; doc=12-3-30-CHOKYO; desc=姓15+名15（外国人は連続30）',
  `ChokyosiRyakusyo` varchar(8) DEFAULT NULL COMMENT '[COL] name=調教師名略称; column=ChokyosiRyakusyo; table=S_CHOKYO; class=速報系; unit=全角4; doc=12-3-30-CHOKYO',
  `ChokyosiNameEng` varchar(80) DEFAULT NULL COMMENT '[COL] name=調教師名欧字; column=ChokyosiNameEng; table=S_CHOKYO; class=速報系; unit=半角80; doc=12-3-30-CHOKYO; desc=姓+半角空白1+名（フルネーム）',
  `SexCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別区分; column=SexCD; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=1男性/2女性',
  `TozaiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=調教師東西所属コード; column=TozaiCD; table=S_CHOKYO; class=速報系; ref=code:2301; doc=12-3-30-CHOKYO',
  `Syotai` varchar(20) DEFAULT NULL COMMENT '[COL] name=招待地域名; column=Syotai; table=S_CHOKYO; class=速報系; unit=全角10; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1SaikinJyusyoid` varchar(16) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_年月日場回日R; column=SaikinJyusyo1SaikinJyusyoid; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=レース詳細のキー情報',
  `SaikinJyusyo1Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_競走名本題; column=SaikinJyusyo1Hondai; table=S_CHOKYO; class=速報系; unit=全角30; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_競走名略称10字; column=SaikinJyusyo1Ryakusyo10; table=S_CHOKYO; class=速報系; unit=全角10; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_競走名略称6字; column=SaikinJyusyo1Ryakusyo6; table=S_CHOKYO; class=速報系; unit=全角6; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_競走名略称3字; column=SaikinJyusyo1Ryakusyo3; table=S_CHOKYO; class=速報系; unit=全角3; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_グレードコード; column=SaikinJyusyo1GradeCD; table=S_CHOKYO; class=速報系; ref=code:2003; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_出走頭数; column=SaikinJyusyo1SyussoTosu; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=取消・除外等を除いた頭数',
  `SaikinJyusyo1KettoNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_血統登録番号; column=SaikinJyusyo1KettoNum; table=S_CHOKYO; class=速報系; unit=yyyy+品種1+5桁; ref=code:2201; doc=12-3-30-CHOKYO',
  `SaikinJyusyo1Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利1_馬名; column=SaikinJyusyo1Bamei; table=S_CHOKYO; class=速報系; unit=全角18; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2SaikinJyusyoid` varchar(16) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_年月日場回日R; column=SaikinJyusyo2SaikinJyusyoid; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=レース詳細のキー情報',
  `SaikinJyusyo2Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_競走名本題; column=SaikinJyusyo2Hondai; table=S_CHOKYO; class=速報系; unit=全角30; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_競走名略称10字; column=SaikinJyusyo2Ryakusyo10; table=S_CHOKYO; class=速報系; unit=全角10; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_競走名略称6字; column=SaikinJyusyo2Ryakusyo6; table=S_CHOKYO; class=速報系; unit=全角6; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_競走名略称3字; column=SaikinJyusyo2Ryakusyo3; table=S_CHOKYO; class=速報系; unit=全角3; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_グレードコード; column=SaikinJyusyo2GradeCD; table=S_CHOKYO; class=速報系; ref=code:2003; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_出走頭数; column=SaikinJyusyo2SyussoTosu; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=取消・除外等を除いた頭数',
  `SaikinJyusyo2KettoNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_血統登録番号; column=SaikinJyusyo2KettoNum; table=S_CHOKYO; class=速報系; unit=yyyy+品種1+5桁; ref=code:2201; doc=12-3-30-CHOKYO',
  `SaikinJyusyo2Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利2_馬名; column=SaikinJyusyo2Bamei; table=S_CHOKYO; class=速報系; unit=全角18; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3SaikinJyusyoid` varchar(16) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_年月日場回日R; column=SaikinJyusyo3SaikinJyusyoid; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=レース詳細のキー情報',
  `SaikinJyusyo3Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_競走名本題; column=SaikinJyusyo3Hondai; table=S_CHOKYO; class=速報系; unit=全角30; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_競走名略称10字; column=SaikinJyusyo3Ryakusyo10; table=S_CHOKYO; class=速報系; unit=全角10; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_競走名略称6字; column=SaikinJyusyo3Ryakusyo6; table=S_CHOKYO; class=速報系; unit=全角6; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_競走名略称3字; column=SaikinJyusyo3Ryakusyo3; table=S_CHOKYO; class=速報系; unit=全角3; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_グレードコード; column=SaikinJyusyo3GradeCD; table=S_CHOKYO; class=速報系; ref=code:2003; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_出走頭数; column=SaikinJyusyo3SyussoTosu; table=S_CHOKYO; class=速報系; doc=12-3-30-CHOKYO; desc=取消・除外等を除いた頭数',
  `SaikinJyusyo3KettoNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_血統登録番号; column=SaikinJyusyo3KettoNum; table=S_CHOKYO; class=速報系; unit=yyyy+品種1+5桁; ref=code:2201; doc=12-3-30-CHOKYO',
  `SaikinJyusyo3Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=最近重賞勝利3_馬名; column=SaikinJyusyo3Bamei; table=S_CHOKYO; class=速報系; unit=全角18; doc=12-3-30-CHOKYO',
  PRIMARY KEY (`ChokyosiCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=調教師マスタ; table=S_CHOKYO; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
