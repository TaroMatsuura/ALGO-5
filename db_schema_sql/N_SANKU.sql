-- Table structure for table `N_SANKU`
-- Table structure for table `N_SANKU`
--

DROP TABLE IF EXISTS `N_SANKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_SANKU` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU; desc=SKでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU; desc=1新規登録/2更新/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_SANKU; class=蓄積系; unit=yyyymmdd; doc=12-3-35-SANKU; desc=西暦4桁+月日各2桁',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU; desc=生年(西暦)4桁+品種1桁+数字5桁',
  `BirthDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=生年月日; column=BirthDate; table=N_SANKU; class=蓄積系; unit=yyyymmdd; doc=12-3-35-SANKU',
  `SexCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード; column=SexCD; table=N_SANKU; class=蓄積系; ref=code:2202; doc=12-3-35-SANKU',
  `HinsyuCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=品種コード; column=HinsyuCD; table=N_SANKU; class=蓄積系; ref=code:2201; doc=12-3-35-SANKU',
  `KeiroCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=毛色コード; column=KeiroCD; table=N_SANKU; class=蓄積系; ref=code:2203; doc=12-3-35-SANKU',
  `SankuMochiKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=産駒持込区分; column=SankuMochiKubun; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU; desc=0内国産/1持込/2輸入内国産扱い/3輸入',
  `ImportYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=輸入年; column=ImportYear; table=N_SANKU; class=蓄積系; unit=yyyy; doc=12-3-35-SANKU',
  `BreederCode` varchar(8) DEFAULT NULL COMMENT '[COL] name=生産者コード; column=BreederCode; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU; desc=生産者マスタにリンク',
  `SanchiName` varchar(20) DEFAULT NULL COMMENT '[COL] name=産地名; column=SanchiName; table=N_SANKU; class=蓄積系; unit=全角10; doc=12-3-35-SANKU',
  `FNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父繁殖登録番号; column=FNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母繁殖登録番号; column=MNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `FFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父父繁殖登録番号; column=FFNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `FMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父母繁殖登録番号; column=FMNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母父繁殖登録番号; column=MFNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母母繁殖登録番号; column=MMNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `FFFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父父父繁殖登録番号; column=FFFNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `FFMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父父母繁殖登録番号; column=FFMNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `FMFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父母父繁殖登録番号; column=FMFNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `FMMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父母母繁殖登録番号; column=FMMNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MFFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母父父繁殖登録番号; column=MFFNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MFMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母父母繁殖登録番号; column=MFMNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MMFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母母父繁殖登録番号; column=MMFNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  `MMMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母母母繁殖登録番号; column=MMMNum; table=N_SANKU; class=蓄積系; doc=12-3-35-SANKU',
  PRIMARY KEY (`KettoNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=産駒マスタ; table=N_SANKU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
