-- Table structure for table `S_TOKU_RACE`
-- Table structure for table `S_TOKU_RACE`
--

DROP TABLE IF EXISTS `S_TOKU_RACE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_TOKU_RACE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=TKでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=1:ハンデ発表前 2:発表後 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_TOKU_RACE; class=速報系; unit=yyyymmdd; doc=12-3-01-TOKU_RACE; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_TOKU_RACE; class=速報系; unit=yyyy; doc=12-3-01-TOKU_RACE; desc=施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_TOKU_RACE; class=速報系; unit=mmdd; doc=12-3-01-TOKU_RACE; desc=施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_TOKU_RACE; class=速報系; ref=code:2001; doc=12-3-01-TOKU_RACE; desc=施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=同年同場での開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=開催回内の何日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=該当レース番号',
  `YoubiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=曜日コード; column=YoubiCD; table=S_TOKU_RACE; class=速報系; ref=code:2002; doc=12-3-01-TOKU_RACE; desc=施行曜日',
  `TokuNum` varchar(4) DEFAULT NULL COMMENT '[COL] name=特別競走番号; column=TokuNum; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=重賞のみ設定・同一レースで共通',
  `Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=競走名本題; column=Hondai; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=レース名の本題',
  `Fukudai` varchar(60) DEFAULT NULL COMMENT '[COL] name=競走名副題; column=Fukudai; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=スポンサー名・記念名等',
  `Kakko` varchar(60) DEFAULT NULL COMMENT '[COL] name=競走名カッコ内; column=Kakko; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=条件や通称・トライアル対象等',
  `HondaiEng` varchar(120) DEFAULT NULL COMMENT '[COL] name=競走名本題欧字; column=HondaiEng; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=英字本題',
  `FukudaiEng` varchar(120) DEFAULT NULL COMMENT '[COL] name=競走名副題欧字; column=FukudaiEng; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=英字副題',
  `KakkoEng` varchar(120) DEFAULT NULL COMMENT '[COL] name=競走名カッコ内欧字; column=KakkoEng; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=英字カッコ内',
  `Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=競走名略称10字; column=Ryakusyo10; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=全角10字略称',
  `Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=競走名略称6字; column=Ryakusyo6; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=全角6字略称',
  `Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=競走名略称3字; column=Ryakusyo3; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=全角3字略称',
  `Kubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=競走名区分; column=Kubun; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=重賞回次の付与位置',
  `Nkai` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞回次; column=Nkai; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=重賞としての通算回数',
  `GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=グレードコード; column=GradeCD; table=S_TOKU_RACE; class=速報系; ref=code:2003; doc=12-3-01-TOKU_RACE; desc=GI/GII/GIII等',
  `SyubetuCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=競走種別コード; column=SyubetuCD; table=S_TOKU_RACE; class=速報系; ref=code:2005; doc=12-3-01-TOKU_RACE; desc=競走種別',
  `KigoCD` varchar(3) DEFAULT NULL COMMENT '[COL] name=競走記号コード; column=KigoCD; table=S_TOKU_RACE; class=速報系; ref=code:2006; doc=12-3-01_TOKU_RACE; desc=記号(国際・牝等)',
  `JyuryoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重量種別コード; column=JyuryoCD; table=S_TOKU_RACE; class=速報系; ref=code:2008; doc=12-3-01_TOKU_RACE; desc=定量/ハンデ等',
  `JyokenCD1` varchar(3) DEFAULT NULL COMMENT '[COL] name=競走条件コード(2歳); column=JyokenCD1; table=S_TOKU_RACE; class=速報系; ref=code:2007; doc=12-3-01-TOKU_RACE; desc=2歳条件',
  `JyokenCD2` varchar(3) DEFAULT NULL COMMENT '[COL] name=競走条件コード(3歳); column=JyokenCD2; table=S_TOKU_RACE; class=速報系; ref=code:2007; doc=12-3-01-TOKU_RACE; desc=3歳条件',
  `JyokenCD3` varchar(3) DEFAULT NULL COMMENT '[COL] name=競走条件コード(4歳); column=JyokenCD3; table=S_TOKU_RACE; class=速報系; ref=code:2007; doc=12-3-01-TOKU_RACE; desc=4歳条件',
  `JyokenCD4` varchar(3) DEFAULT NULL COMMENT '[COL] name=競走条件コード(5歳以上); column=JyokenCD4; table=S_TOKU_RACE; class=速報系; ref=code:2007; doc=12-3-01-TOKU_RACE; desc=5歳以上条件',
  `JyokenCD5` varchar(3) DEFAULT NULL COMMENT '[COL] name=競走条件コード(最若年); column=JyokenCD5; table=S_TOKU_RACE; class=速報系; ref=code:2007; doc=12-3-01-TOKU_RACE; desc=最若年条件',
  `Kyori` varchar(4) DEFAULT NULL COMMENT '[COL] name=距離; column=Kyori; table=S_TOKU_RACE; class=速報系; unit=m; doc=12-3-01-TOKU_RACE; desc=メートル',
  `TrackCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=トラックコード; column=TrackCD; table=S_TOKU_RACE; class=速報系; ref=code:2009; doc=12-3-01-TOKU_RACE; desc=芝/ダ/障等',
  `CourseKubunCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=コース区分; column=CourseKubunCD; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=A～E等の使用コース',
  `HandiDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=ハンデ発表日; column=HandiDate; table=S_TOKU_RACE; class=速報系; unit=yyyymmdd; doc=12-3-01-TOKU_RACE; desc=ハンデ公表日',
  `TorokuTosu` varchar(3) DEFAULT NULL COMMENT '[COL] name=登録頭数; column=TorokuTosu; table=S_TOKU_RACE; class=速報系; doc=12-3-01-TOKU_RACE; desc=特別登録頭数',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=特別レース; table=S_TOKU_RACE; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
