-- Table structure for table `S_COURSE_CHANGE`
-- Table structure for table `S_COURSE_CHANGE`
--

DROP TABLE IF EXISTS `S_COURSE_CHANGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_COURSE_CHANGE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_COURSE_CHANGE; class=速報系; doc=12-3-43-COURSE_CHANGE; desc=CCでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_COURSE_CHANGE; class=速報系; doc=12-3-43-COURSE_CHANGE; vals=1:初期値',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_COURSE_CHANGE; class=速報系; unit=yyyymmdd; doc=12-3-43-COURSE_CHANGE; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_COURSE_CHANGE; class=速報系; unit=yyyy; key=○; doc=12-3-43-COURSE_CHANGE',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_COURSE_CHANGE; class=速報系; unit=mmdd; key=○; doc=12-3-43-COURSE_CHANGE',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_COURSE_CHANGE; class=速報系; ref=code:2001; key=○; doc=12-3-43-COURSE_CHANGE',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_COURSE_CHANGE; class=速報系; key=○; doc=12-3-43-COURSE_CHANGE; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_COURSE_CHANGE; class=速報系; key=○; doc=12-3-43-COURSE_CHANGE; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_COURSE_CHANGE; class=速報系; key=○; doc=12-3-43-COURSE_CHANGE',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_COURSE_CHANGE; class=速報系; unit=mmddhhmm; key=○; doc=12-3-43-COURSE_CHANGE; desc=月日+時分の各2桁',
  `AtoKyori` varchar(4) DEFAULT NULL COMMENT '[COL] name=変更後情報_距離; column=AtoKyori; table=S_COURSE_CHANGE; class=速報系; unit=m; doc=12-3-43-COURSE_CHANGE',
  `AtoTruckCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=変更後情報_トラックコード; column=AtoTruckCD; table=S_COURSE_CHANGE; class=速報系; ref=code:2009; doc=12-3-43-COURSE_CHANGE',
  `MaeKyori` varchar(4) DEFAULT NULL COMMENT '[COL] name=変更前情報_距離; column=MaeKyori; table=S_COURSE_CHANGE; class=速報系; unit=m; doc=12-3-43-COURSE_CHANGE',
  `MaeTruckCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=変更前情報_トラックコード; column=MaeTruckCD; table=S_COURSE_CHANGE; class=速報系; ref=code:2009; doc=12-3-43-COURSE_CHANGE',
  `JiyuCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=事由コード; column=JiyuCD; table=S_COURSE_CHANGE; class=速報系; doc=12-3-43-COURSE_CHANGE; vals=1:強風 2:台風 3:雪 4:その他',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=コース変更; table=S_COURSE_CHANGE; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
