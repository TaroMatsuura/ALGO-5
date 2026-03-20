-- Table structure for table `S_RECORD`
-- Table structure for table `S_RECORD`
--

DROP TABLE IF EXISTS `S_RECORD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_RECORD` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; desc=RCでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; desc=1初期値/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_RECORD; class=速報系; unit=yyyymmdd; doc=12-3-36-RECORD',
  `RecInfoKubun` varchar(1) NOT NULL COMMENT '[COL] name=レコード識別区分; column=RecInfoKubun; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; key=○; desc=1:コースレコード 2:GⅠレコード',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_RECORD; class=速報系; unit=yyyy; doc=12-3-36-RECORD; key=○',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_RECORD; class=速報系; unit=mmdd; doc=12-3-36-RECORD; key=○',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_RECORD; class=速報系; ref=code:2001; doc=12-3-36-RECORD; key=○',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; key=○; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; key=○; desc=その開催のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; key=○',
  `TokuNum` varchar(4) NOT NULL COMMENT '[COL] name=特別競走番号; column=TokuNum; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; key=GⅠのみ',
  `Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=競走名本題; column=Hondai; table=S_RECORD; class=速報系; unit=全角30; doc=12-3-36-RECORD',
  `GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=グレードコード; column=GradeCD; table=S_RECORD; class=速報系; ref=code:2003; doc=12-3-36-RECORD',
  `SyubetuCD` varchar(2) NOT NULL COMMENT '[COL] name=競走種別コード; column=SyubetuCD; table=S_RECORD; class=速報系; ref=code:2005; doc=12-3-36-RECORD; key=○',
  `Kyori` varchar(4) NOT NULL COMMENT '[COL] name=距離; column=Kyori; table=S_RECORD; class=速報系; unit=m; doc=12-3-36-RECORD; key=○',
  `TrackCD` varchar(2) NOT NULL COMMENT '[COL] name=トラックコード; column=TrackCD; table=S_RECORD; class=速報系; ref=code:2009; doc=12-3-36-RECORD; key=○',
  `RecKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=レコード区分; column=RecKubun; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; desc=1:基準 2:レコード 3:参考 4:備考',
  `RecTime` varchar(4) DEFAULT NULL COMMENT '[COL] name=レコードタイム; column=RecTime; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; format=9分99秒9',
  `TenkoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=天候コード; column=TenkoCD; table=S_RECORD; class=速報系; ref=code:2011; doc=12-3-36-RECORD',
  `SibaBabaCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=芝馬場状態コード; column=SibaBabaCD; table=S_RECORD; class=速報系; ref=code:2010; doc=12-3-36-RECORD',
  `DirtBabaCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=ダート馬場状態コード; column=DirtBabaCD; table=S_RECORD; class=速報系; ref=code:2010; doc=12-3-36-RECORD',
  `RecUmaKettoNum1` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号1; column=RecUmaKettoNum1; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; desc=yyyy+品種1+5桁',
  `RecUmaBamei1` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名1; column=RecUmaBamei1; table=S_RECORD; class=速報系; unit=全角18; doc=12-3-36-RECORD',
  `RecUmaUmaKigoCD1` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬記号コード1; column=RecUmaUmaKigoCD1; table=S_RECORD; class=速報系; ref=code:2204; doc=12-3-36-RECORD',
  `RecUmaSexCD1` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード1; column=RecUmaSexCD1; table=S_RECORD; class=速報系; ref=code:2202; doc=12-3-36-RECORD',
  `RecUmaChokyosiCode1` varchar(5) DEFAULT NULL COMMENT '[COL] name=調教師コード1; column=RecUmaChokyosiCode1; table=S_RECORD; class=速報系; doc=12-3-36-RECORD',
  `RecUmaChokyosiName1` varchar(34) DEFAULT NULL COMMENT '[COL] name=調教師名1; column=RecUmaChokyosiName1; table=S_RECORD; class=速報系; unit=全角17; doc=12-3-36-RECORD; desc=姓+全角空白1+名（外国人は連続17）',
  `RecUmaFutan1` varchar(3) DEFAULT NULL COMMENT '[COL] name=負担重量1; column=RecUmaFutan1; table=S_RECORD; class=速報系; unit=0.1kg; doc=12-3-36-RECORD',
  `RecUmaKisyuCode1` varchar(5) DEFAULT NULL COMMENT '[COL] name=騎手コード1; column=RecUmaKisyuCode1; table=S_RECORD; class=速報系; doc=12-3-36-RECORD',
  `RecUmaKisyuName1` varchar(34) DEFAULT NULL COMMENT '[COL] name=騎手名1; column=RecUmaKisyuName1; table=S_RECORD; class=速報系; unit=全角17; doc=12-3-36-RECORD; desc=姓+全角空白1+名（外国人は連続17）',
  `RecUmaKettoNum2` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号2; column=RecUmaKettoNum2; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; desc=yyyy+品種1+5桁',
  `RecUmaBamei2` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名2; column=RecUmaBamei2; table=S_RECORD; class=速報系; unit=全角18; doc=12-3-36-RECORD',
  `RecUmaUmaKigoCD2` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬記号コード2; column=RecUmaUmaKigoCD2; table=S_RECORD; class=速報系; ref=code:2204; doc=12-3-36-RECORD',
  `RecUmaSexCD2` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード2; column=RecUmaSexCD2; table=S_RECORD; class=速報系; ref=code:2202; doc=12-3-36-RECORD',
  `RecUmaChokyosiCode2` varchar(5) DEFAULT NULL COMMENT '[COL] name=調教師コード2; column=RecUmaChokyosiCode2; table=S_RECORD; class=速報系; doc=12-3-36-RECORD',
  `RecUmaChokyosiName2` varchar(34) DEFAULT NULL COMMENT '[COL] name=調教師名2; column=RecUmaChokyosiName2; table=S_RECORD; class=速報系; unit=全角17; doc=12-3-36-RECORD; desc=姓+全角空白1+名（外国人は連続17）',
  `RecUmaFutan2` varchar(3) DEFAULT NULL COMMENT '[COL] name=負担重量2; column=RecUmaFutan2; table=S_RECORD; class=速報系; unit=0.1kg; doc=12-3-36-RECORD',
  `RecUmaKisyuCode2` varchar(5) DEFAULT NULL COMMENT '[COL] name=騎手コード2; column=RecUmaKisyuCode2; table=S_RECORD; class=速報系; doc=12-3-36-RECORD',
  `RecUmaKisyuName2` varchar(34) DEFAULT NULL COMMENT '[COL] name=騎手名2; column=RecUmaKisyuName2; table=S_RECORD; class=速報系; unit=全角17; doc=12-3-36-RECORD; desc=姓+全角空白1+名（外国人は連続17）',
  `RecUmaKettoNum3` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号3; column=RecUmaKettoNum3; table=S_RECORD; class=速報系; doc=12-3-36-RECORD; desc=yyyy+品種1+5桁',
  `RecUmaBamei3` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名3; column=RecUmaBamei3; table=S_RECORD; class=速報系; unit=全角18; doc=12-3-36-RECORD',
  `RecUmaUmaKigoCD3` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬記号コード3; column=RecUmaUmaKigoCD3; table=S_RECORD; class=速報系; ref=code:2204; doc=12-3-36-RECORD',
  `RecUmaSexCD3` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード3; column=RecUmaSexCD3; table=S_RECORD; class=速報系; ref=code:2202; doc=12-3-36-RECORD',
  `RecUmaChokyosiCode3` varchar(5) DEFAULT NULL COMMENT '[COL] name=調教師コード3; column=RecUmaChokyosiCode3; table=S_RECORD; class=速報系; doc=12-3-36-RECORD',
  `RecUmaChokyosiName3` varchar(34) DEFAULT NULL COMMENT '[COL] name=調教師名3; column=RecUmaChokyosiName3; table=S_RECORD; class=速報系; unit=全角17; doc=12-3-36-RECORD; desc=姓+全角空白1+名（外国人は連続17）',
  `RecUmaFutan3` varchar(3) DEFAULT NULL COMMENT '[COL] name=負担重量3; column=RecUmaFutan3; table=S_RECORD; class=速報系; unit=0.1kg; doc=12-3-36-RECORD',
  `RecUmaKisyuCode3` varchar(5) DEFAULT NULL COMMENT '[COL] name=騎手コード3; column=RecUmaKisyuCode3; table=S_RECORD; class=速報系; doc=12-3-36-RECORD',
  `RecUmaKisyuName3` varchar(34) DEFAULT NULL COMMENT '[COL] name=騎手名3; column=RecUmaKisyuName3; table=S_RECORD; class=速報系; unit=全角17; doc=12-3-36-RECORD; desc=姓+全角空白1+名（外国人は連続17）',
  PRIMARY KEY (`RecInfoKubun`,`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`TokuNum`,`SyubetuCD`,`Kyori`,`TrackCD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=レコードマスタ; table=S_RECORD; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
