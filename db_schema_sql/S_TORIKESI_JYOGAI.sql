-- Table structure for table `S_TORIKESI_JYOGAI`
-- Table structure for table `S_TORIKESI_JYOGAI`
--

DROP TABLE IF EXISTS `S_TORIKESI_JYOGAI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_TORIKESI_JYOGAI` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_TORIKESI_JYOGAI; class=速報系; doc=12-3-40-TORIKESI_JYOGAI; desc=AVでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_TORIKESI_JYOGAI; class=速報系; doc=12-3-40-TORIKESI_JYOGAI; vals=1:出走取消 2:競走除外',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_TORIKESI_JYOGAI; class=速報系; unit=yyyymmdd; doc=12-3-40-TORIKESI_JYOGAI; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_TORIKESI_JYOGAI; class=速報系; unit=yyyy; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_TORIKESI_JYOGAI; class=速報系; unit=mmdd; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_TORIKESI_JYOGAI; class=速報系; ref=code:2001; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=該当レース施行競馬場',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_TORIKESI_JYOGAI; class=速報系; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_TORIKESI_JYOGAI; class=速報系; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_TORIKESI_JYOGAI; class=速報系; key=○; doc=12-3-40-TORIKESI_JYOGAI',
  `HappyoTime` varchar(8) DEFAULT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_TORIKESI_JYOGAI; class=速報系; unit=mmddhhmm; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=月日+時分の各2桁',
  `Umaban` varchar(2) NOT NULL COMMENT '[COL] name=馬番; column=Umaban; table=S_TORIKESI_JYOGAI; class=速報系; key=○; doc=12-3-40-TORIKESI_JYOGAI; desc=01～18を設定',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=S_TORIKESI_JYOGAI; class=速報系; unit=全角18; doc=12-3-40-TORIKESI_JYOGAI; note=当面は全角9まで設定',
  `JiyuKubun` varchar(3) DEFAULT NULL COMMENT '[COL] name=事由区分; column=JiyuKubun; table=S_TORIKESI_JYOGAI; class=速報系; doc=12-3-40-TORIKESI_JYOGAI; vals=000:初期値 001:疾病 002:事故 003:その他',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`Umaban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=出走取消・競走除外; table=S_TORIKESI_JYOGAI; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
