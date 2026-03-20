-- Table structure for table `S_KISYU_CHANGE`
-- Table structure for table `S_KISYU_CHANGE`
--

DROP TABLE IF EXISTS `S_KISYU_CHANGE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_KISYU_CHANGE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_KISYU_CHANGE; class=速報系; doc=12-3-41-KISYU_CHANGE; desc=JCでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_KISYU_CHANGE; class=速報系; doc=12-3-41-KISYU_CHANGE; vals=1:初期値',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_KISYU_CHANGE; class=速報系; unit=yyyymmdd; doc=12-3-41-KISYU_CHANGE; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_KISYU_CHANGE; class=速報系; unit=yyyy; key=○; doc=12-3-41-KISYU_CHANGE',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_KISYU_CHANGE; class=速報系; unit=mmdd; key=○; doc=12-3-41-KISYU_CHANGE',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_KISYU_CHANGE; class=速報系; ref=code:2001; key=○; doc=12-3-41-KISYU_CHANGE',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_KISYU_CHANGE; class=速報系; key=○; doc=12-3-41-KISYU_CHANGE; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_KISYU_CHANGE; class=速報系; key=○; doc=12-3-41-KISYU_CHANGE; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_KISYU_CHANGE; class=速報系; key=○; doc=12-3-41-KISYU_CHANGE',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_KISYU_CHANGE; class=速報系; unit=mmddhhmm; key=○; doc=12-3-41-KISYU_CHANGE; desc=月日+時分の各2桁',
  `Umaban` varchar(2) NOT NULL COMMENT '[COL] name=馬番; column=Umaban; table=S_KISYU_CHANGE; class=速報系; key=○; doc=12-3-41-KISYU_CHANGE; desc=01～18を設定',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=S_KISYU_CHANGE; class=速報系; unit=全角18; doc=12-3-41-KISYU_CHANGE; note=当面は全角9まで設定',
  `AtoFutan` varchar(3) DEFAULT NULL COMMENT '[COL] name=変更後情報_負担重量; column=AtoFutan; table=S_KISYU_CHANGE; class=速報系; unit=0.1kg; doc=12-3-41-KISYU_CHANGE',
  `AtoKisyuCode` varchar(5) DEFAULT NULL COMMENT '[COL] name=変更後情報_騎手コード; column=AtoKisyuCode; table=S_KISYU_CHANGE; class=速報系; doc=12-3-41-KISYU_CHANGE; link=騎手マスタ; note=未定時は00000(ALL0)',
  `AtoKisyuName` varchar(34) DEFAULT NULL COMMENT '[COL] name=変更後情報_騎手名; column=AtoKisyuName; table=S_KISYU_CHANGE; class=速報系; unit=全角17; doc=12-3-41-KISYU_CHANGE; note=当面は全角8まで/未定時は"未定"',
  `AtoMinaraiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=変更後情報_騎手見習コード; column=AtoMinaraiCD; table=S_KISYU_CHANGE; class=速報系; ref=code:2303; doc=12-3-41-KISYU_CHANGE',
  `MaeFutan` varchar(3) DEFAULT NULL COMMENT '[COL] name=変更前情報_負担重量; column=MaeFutan; table=S_KISYU_CHANGE; class=速報系; unit=0.1kg; doc=12-3-41-KISYU_CHANGE',
  `MaeKisyuCode` varchar(5) DEFAULT NULL COMMENT '[COL] name=変更前情報_騎手コード; column=MaeKisyuCode; table=S_KISYU_CHANGE; class=速報系; doc=12-3-41-KISYU_CHANGE; link=騎手マスタ',
  `MaeKisyuName` varchar(34) DEFAULT NULL COMMENT '[COL] name=変更前情報_騎手名; column=MaeKisyuName; table=S_KISYU_CHANGE; class=速報系; unit=全角17; doc=12-3-41-KISYU_CHANGE; note=当面は全角8まで',
  `MaeMinaraiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=変更前情報_騎手見習コード; column=MaeMinaraiCD; table=S_KISYU_CHANGE; class=速報系; ref=code:2303; doc=12-3-41-KISYU_CHANGE',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`,`Umaban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=騎手変更; table=S_KISYU_CHANGE; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
