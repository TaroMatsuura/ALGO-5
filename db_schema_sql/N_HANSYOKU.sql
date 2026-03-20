-- Table structure for table `N_HANSYOKU`
-- Table structure for table `N_HANSYOKU`
--

DROP TABLE IF EXISTS `N_HANSYOKU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_HANSYOKU` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU; desc=HNでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU; desc=1新規登録/2更新/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_HANSYOKU; class=蓄積系; unit=yyyymmdd; doc=12-3-34-HANSYOKU; desc=西暦4桁+月日各2桁',
  `HansyokuNum` varchar(10) NOT NULL COMMENT '[COL] name=繁殖登録番号; column=HansyokuNum; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU; key=○; desc=同一馬で複数番号を持つ場合あり',
  `reserved` varchar(8) DEFAULT NULL COMMENT '[COL] name=予備; column=reserved; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU',
  `KettoNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU; desc=外国の繁殖馬等の理由で初期値の場合あり',
  `DelKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=繁殖馬抹消区分; column=DelKubun; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU; desc=0を設定',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=N_HANSYOKU; class=蓄積系; unit=全角18/半角36; doc=12-3-34-HANSYOKU; desc=外国馬は馬名欧字の先頭36Bを設定',
  `BameiKana` varchar(40) DEFAULT NULL COMMENT '[COL] name=馬名半角ｶﾅ; column=BameiKana; table=N_HANSYOKU; class=蓄積系; unit=半角40; doc=12-3-34-HANSYOKU; desc=半角ｶﾅのみ/外国は空',
  `BameiEng` varchar(80) DEFAULT NULL COMMENT '[COL] name=馬名欧字; column=BameiEng; table=N_HANSYOKU; class=蓄積系; unit=全角40/半角80; doc=12-3-34-HANSYOKU; desc=特殊記号は全角で設定',
  `BirthYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=生年; column=BirthYear; table=N_HANSYOKU; class=蓄積系; unit=yyyy; doc=12-3-34-HANSYOKU',
  `SexCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード; column=SexCD; table=N_HANSYOKU; class=蓄積系; ref=code:2202; doc=12-3-34-HANSYOKU',
  `HinsyuCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=品種コード; column=HinsyuCD; table=N_HANSYOKU; class=蓄積系; ref=code:2201; doc=12-3-34-HANSYOKU',
  `KeiroCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=毛色コード; column=KeiroCD; table=N_HANSYOKU; class=蓄積系; ref=code:2203; doc=12-3-34-HANSYOKU',
  `HansyokuMochiKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=繁殖馬持込区分; column=HansyokuMochiKubun; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU; desc=0内国産/1持込/2輸入内国産扱い/3輸入/9その他',
  `ImportYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=輸入年; column=ImportYear; table=N_HANSYOKU; class=蓄積系; unit=yyyy; doc=12-3-34-HANSYOKU',
  `SanchiName` varchar(20) DEFAULT NULL COMMENT '[COL] name=産地名; column=SanchiName; table=N_HANSYOKU; class=蓄積系; unit=全角10; doc=12-3-34-HANSYOKU',
  `HansyokuFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父馬繁殖登録番号; column=HansyokuFNum; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU',
  `HansyokuMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母馬繁殖登録番号; column=HansyokuMNum; table=N_HANSYOKU; class=蓄積系; doc=12-3-34-HANSYOKU',
  PRIMARY KEY (`HansyokuNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=繁殖馬マスタ; table=N_HANSYOKU; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
