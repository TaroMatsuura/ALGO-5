-- Table structure for table `N_SALE`
-- Table structure for table `N_SALE`
--

DROP TABLE IF EXISTS `N_SALE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_SALE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_SALE; class=蓄積系; doc=12-3-51-SALE; desc=HSでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_SALE; class=蓄積系; doc=12-3-51-SALE; vals=1:初期値 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_SALE; class=蓄積系; unit=yyyymmdd; doc=12-3-51-SALE',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=N_SALE; class=蓄積系; key=○; doc=12-3-51-SALE; link=競走馬マスタ',
  `HansyokuFNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=父馬繁殖登録番号; column=HansyokuFNum; table=N_SALE; class=蓄積系; doc=12-3-51-SALE; link=繁殖馬マスタ',
  `HansyokuMNum` varchar(10) DEFAULT NULL COMMENT '[COL] name=母馬繁殖登録番号; column=HansyokuMNum; table=N_SALE; class=蓄積系; doc=12-3-51-SALE; link=繁殖馬マスタ',
  `BirthYear` varchar(4) DEFAULT NULL COMMENT '[COL] name=生年; column=BirthYear; table=N_SALE; class=蓄積系; unit=yyyy; doc=12-3-51-SALE; desc=競走馬の生年',
  `SaleCode` varchar(6) NOT NULL COMMENT '[COL] name=主催者・市場コード; column=SaleCode; table=N_SALE; class=蓄積系; key=○; doc=12-3-51-SALE; desc=主催者・市場毎にユニーク',
  `SaleHostName` varchar(40) DEFAULT NULL COMMENT '[COL] name=主催者名称; column=SaleHostName; table=N_SALE; class=蓄積系; doc=12-3-51-SALE',
  `SaleName` varchar(80) DEFAULT NULL COMMENT '[COL] name=市場の名称; column=SaleName; table=N_SALE; class=蓄積系; doc=12-3-51-SALE',
  `FromDate` varchar(8) NOT NULL COMMENT '[COL] name=市場の開催期間(開始日); column=FromDate; table=N_SALE; class=蓄積系; key=○; unit=yyyymmdd; doc=12-3-51-SALE; note=同一馬が複数回取引される可能性を考慮してキー設定',
  `ToDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=市場の開催期間(終了日); column=ToDate; table=N_SALE; class=蓄積系; unit=yyyymmdd; doc=12-3-51-SALE',
  `Barei` varchar(1) DEFAULT NULL COMMENT '[COL] name=取引時の年齢; column=Barei; table=N_SALE; class=蓄積系; doc=12-3-51-SALE; vals=0:0歳 1:1歳 2:2歳 3:3歳 4:4歳… (値=年齢に対応)',
  `Price` varchar(10) DEFAULT NULL COMMENT '[COL] name=取引価格; column=Price; table=N_SALE; class=蓄積系; unit=円; doc=12-3-51-SALE',
  PRIMARY KEY (`KettoNum`,`SaleCode`,`FromDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=競走馬市場取引価格; table=N_SALE; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
