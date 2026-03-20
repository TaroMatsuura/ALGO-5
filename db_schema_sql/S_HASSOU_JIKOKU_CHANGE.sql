-- Table structure for table `S_HASSOU_JIKOKU_CHANGE`
-- Table structure for table `S_HASSOU_JIKOKU_CHANGE`
--

DROP TABLE IF EXISTS `S_HASSOU_JIKOKU_CHANGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_HASSOU_JIKOKU_CHANGE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; doc=12-3-42-HASSOU_JIKOKU_CHANGE; desc=TCでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; doc=12-3-42-HASSOU_JIKOKU_CHANGE; desc=1:初期値',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=yyyymmdd; doc=12-3-42-HASSOU_JIKOKU_CHANGE; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=yyyy; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=mmdd; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; ref=code:2001; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=mmddhhmm; key=○; doc=12-3-42-HASSOU_JIKOKU_CHANGE; desc=月日+時分の各2桁',
  `AtoJi` varchar(2) DEFAULT NULL COMMENT '[COL] name=変更後情報_時; column=AtoJi; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=hh; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `AtoFun` varchar(2) DEFAULT NULL COMMENT '[COL] name=変更後情報_分; column=AtoFun; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=mm; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `MaeJi` varchar(2) DEFAULT NULL COMMENT '[COL] name=変更前情報_時; column=MaeJi; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=hh; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  `MaeFun` varchar(2) DEFAULT NULL COMMENT '[COL] name=変更前情報_分; column=MaeFun; table=S_HASSOU_JIKOKU_CHANGE; class=速報系; unit=mm; doc=12-3-42-HASSOU_JIKOKU_CHANGE',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=発走時刻変更; table=S_HASSOU_JIKOKU_CHANGE; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
