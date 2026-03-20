-- Table structure for table `N_SCHEDULE`
-- Table structure for table `N_SCHEDULE`
--

DROP TABLE IF EXISTS `N_SCHEDULE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_SCHEDULE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE; desc=YSでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE; vals=1:開催予定(年末時点) 2:開催予定(直前時点) 3:開催終了(成績確定) 9:開催中止 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_SCHEDULE; class=蓄積系; unit=yyyymmdd; doc=12-3-45-SCHEDULE; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_SCHEDULE; class=蓄積系; unit=yyyy; key=○; doc=12-3-45-SCHEDULE',
  `MonthDay` varchar(4) NOT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_SCHEDULE; class=蓄積系; unit=mmdd; key=○; doc=12-3-45-SCHEDULE',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2001; key=○; doc=12-3-45-SCHEDULE',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_SCHEDULE; class=蓄積系; key=○; doc=12-3-45-SCHEDULE',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_SCHEDULE; class=蓄積系; key=○; doc=12-3-45-SCHEDULE',
  `YoubiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=曜日コード; column=YoubiCD; table=N_SCHEDULE; class=蓄積系; ref=code:2002; doc=12-3-45-SCHEDULE',
  `Jyusyo1TokuNum` varchar(4) DEFAULT NULL COMMENT '[COL] name=重賞案内1_特別競走番号; column=Jyusyo1TokuNum; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE; desc=重賞のみ設定・同一レースで共通',
  `Jyusyo1Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=重賞案内1_競走名本題; column=Jyusyo1Hondai; table=N_SCHEDULE; class=蓄積系; unit=全角30; doc=12-3-45-SCHEDULE',
  `Jyusyo1Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=重賞案内1_競走名略称10; column=Jyusyo1Ryakusyo10; table=N_SCHEDULE; class=蓄積系; unit=全角10; doc=12-3-45-SCHEDULE',
  `Jyusyo1Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=重賞案内1_競走名略称6; column=Jyusyo1Ryakusyo6; table=N_SCHEDULE; class=蓄積系; unit=全角6; doc=12-3-45-SCHEDULE',
  `Jyusyo1Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=重賞案内1_競走名略称3; column=Jyusyo1Ryakusyo3; table=N_SCHEDULE; class=蓄積系; unit=全角3; doc=12-3-45-SCHEDULE',
  `Jyusyo1Nkai` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞案内1_重賞回次; column=Jyusyo1Nkai; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE; desc=そのレースの重賞としての通算回数',
  `Jyusyo1GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重賞案内1_グレードコード; column=Jyusyo1GradeCD; table=N_SCHEDULE; class=蓄積系; ref=code:2003; doc=12-3-45-SCHEDULE',
  `Jyusyo1SyubetuCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=重賞案内1_競走種別コード; column=Jyusyo1SyubetuCD; table=N_SCHEDULE; class=蓄積系; ref=code:2005; doc=12-3-45-SCHEDULE',
  `Jyusyo1KigoCD` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞案内1_競走記号コード; column=Jyusyo1KigoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2006; doc=12-3-45-SCHEDULE',
  `Jyusyo1JyuryoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重賞案内1_重量種別コード; column=Jyusyo1JyuryoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2008; doc=12-3-45-SCHEDULE',
  `Jyusyo1Kyori` varchar(4) DEFAULT NULL COMMENT '[COL] name=重賞案内1_距離; column=Jyusyo1Kyori; table=N_SCHEDULE; class=蓄積系; unit=m; doc=12-3-45-SCHEDULE',
  `Jyusyo1TrackCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=重賞案内1_トラックコード; column=Jyusyo1TrackCD; table=N_SCHEDULE; class=蓄積系; ref=code:2009; doc=12-3-45-SCHEDULE',
  `Jyusyo2TokuNum` varchar(4) DEFAULT NULL COMMENT '[COL] name=重賞案内2_特別競走番号; column=Jyusyo2TokuNum; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE',
  `Jyusyo2Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=重賞案内2_競走名本題; column=Jyusyo2Hondai; table=N_SCHEDULE; class=蓄積系; unit=全角30; doc=12-3-45-SCHEDULE',
  `Jyusyo2Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=重賞案内2_競走名略称10; column=Jyusyo2Ryakusyo10; table=N_SCHEDULE; class=蓄積系; unit=全角10; doc=12-3-45-SCHEDULE',
  `Jyusyo2Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=重賞案内2_競走名略称6; column=Jyusyo2Ryakusyo6; table=N_SCHEDULE; class=蓄積系; unit=全角6; doc=12-3-45-SCHEDULE',
  `Jyusyo2Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=重賞案内2_競走名略称3; column=Jyusyo2Ryakusyo3; table=N_SCHEDULE; class=蓄積系; unit=全角3; doc=12-3-45-SCHEDULE',
  `Jyusyo2Nkai` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞案内2_重賞回次; column=Jyusyo2Nkai; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE',
  `Jyusyo2GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重賞案内2_グレードコード; column=Jyusyo2GradeCD; table=N_SCHEDULE; class=蓄積系; ref=code:2003; doc=12-3-45-SCHEDULE',
  `Jyusyo2SyubetuCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=重賞案内2_競走種別コード; column=Jyusyo2SyubetuCD; table=N_SCHEDULE; class=蓄積系; ref=code:2005; doc=12-3-45-SCHEDULE',
  `Jyusyo2KigoCD` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞案内2_競走記号コード; column=Jyusyo2KigoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2006; doc=12-3-45-SCHEDULE',
  `Jyusyo2JyuryoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重賞案内2_重量種別コード; column=Jyusyo2JyuryoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2008; doc=12-3-45-SCHEDULE',
  `Jyusyo2Kyori` varchar(4) DEFAULT NULL COMMENT '[COL] name=重賞案内2_距離; column=Jyusyo2Kyori; table=N_SCHEDULE; class=蓄積系; unit=m; doc=12-3-45-SCHEDULE',
  `Jyusyo2TrackCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=重賞案内2_トラックコード; column=Jyusyo2TrackCD; table=N_SCHEDULE; class=蓄積系; ref=code:2009; doc=12-3-45-SCHEDULE',
  `Jyusyo3TokuNum` varchar(4) DEFAULT NULL COMMENT '[COL] name=重賞案内3_特別競走番号; column=Jyusyo3TokuNum; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE',
  `Jyusyo3Hondai` varchar(60) DEFAULT NULL COMMENT '[COL] name=重賞案内3_競走名本題; column=Jyusyo3Hondai; table=N_SCHEDULE; class=蓄積系; unit=全角30; doc=12-3-45-SCHEDULE',
  `Jyusyo3Ryakusyo10` varchar(20) DEFAULT NULL COMMENT '[COL] name=重賞案内3_競走名略称10; column=Jyusyo3Ryakusyo10; table=N_SCHEDULE; class=蓄積系; unit=全角10; doc=12-3-45-SCHEDULE',
  `Jyusyo3Ryakusyo6` varchar(12) DEFAULT NULL COMMENT '[COL] name=重賞案内3_競走名略称6; column=Jyusyo3Ryakusyo6; table=N_SCHEDULE; class=蓄積系; unit=全角6; doc=12-3-45-SCHEDULE',
  `Jyusyo3Ryakusyo3` varchar(6) DEFAULT NULL COMMENT '[COL] name=重賞案内3_競走名略称3; column=Jyusyo3Ryakusyo3; table=N_SCHEDULE; class=蓄積系; unit=全角3; doc=12-3-45-SCHEDULE',
  `Jyusyo3Nkai` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞案内3_重賞回次; column=Jyusyo3Nkai; table=N_SCHEDULE; class=蓄積系; doc=12-3-45-SCHEDULE',
  `Jyusyo3GradeCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重賞案内3_グレードコード; column=Jyusyo3GradeCD; table=N_SCHEDULE; class=蓄積系; ref=code:2003; doc=12-3-45-SCHEDULE',
  `Jyusyo3SyubetuCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=重賞案内3_競走種別コード; column=Jyusyo3SyubetuCD; table=N_SCHEDULE; class=蓄積系; ref=code:2005; doc=12-3-45-SCHEDULE',
  `Jyusyo3KigoCD` varchar(3) DEFAULT NULL COMMENT '[COL] name=重賞案内3_競走記号コード; column=Jyusyo3KigoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2006; doc=12-3-45-SCHEDULE',
  `Jyusyo3JyuryoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=重賞案内3_重量種別コード; column=Jyusyo3JyuryoCD; table=N_SCHEDULE; class=蓄積系; ref=code:2008; doc=12-3-45-SCHEDULE',
  `Jyusyo3Kyori` varchar(4) DEFAULT NULL COMMENT '[COL] name=重賞案内3_距離; column=Jyusyo3Kyori; table=N_SCHEDULE; class=蓄積系; unit=m; doc=12-3-45-SCHEDULE',
  `Jyusyo3TrackCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=重賞案内3_トラックコード; column=Jyusyo3TrackCD; table=N_SCHEDULE; class=蓄積系; ref=code:2009; doc=12-3-45-SCHEDULE',
  PRIMARY KEY (`Year`,`MonthDay`,`JyoCD`,`Kaiji`,`Nichiji`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=開催スケジュール; table=N_SCHEDULE; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
