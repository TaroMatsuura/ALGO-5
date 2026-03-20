-- Table structure for table `S_TENKO_BABA`
-- Table structure for table `S_TENKO_BABA`
--

DROP TABLE IF EXISTS `S_TENKO_BABA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_TENKO_BABA` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_TENKO_BABA; class=速報系; doc=12-3-39-TENKO_BABA; desc=WEでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_TENKO_BABA; class=速報系; doc=12-3-39-TENKO_BABA; desc=1:初期値/0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_TENKO_BABA; class=速報系; unit=yyyymmdd; doc=12-3-39-TENKO_BABA; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_TENKO_BABA; class=速報系; unit=yyyy; doc=12-3-39-TENKO_BABA; key=○; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_TENKO_BABA; class=速報系; unit=mmdd; doc=12-3-39-TENKO_BABA; key=○; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_TENKO_BABA; class=速報系; ref=code:2001; doc=12-3-39-TENKO_BABA; key=○; desc=該当レース施行競馬場',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_TENKO_BABA; class=速報系; doc=12-3-39-TENKO_BABA; key=○; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_TENKO_BABA; class=速報系; doc=12-3-39-TENKO_BABA; key=○; desc=開催回内のN日目',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=S_TENKO_BABA; class=速報系; unit=mmddhhmm; doc=12-3-39-TENKO_BABA; key=○; desc=月日+時分の各2桁',
  `HenkoID` varchar(1) NOT NULL COMMENT '[COL] name=変更識別; column=HenkoID; table=S_TENKO_BABA; class=速報系; doc=12-3-39-TENKO_BABA; key=○; vals=1:初期状態 2:天候変更 3:馬場状態変更; note=1は天候・馬場とも有効値/2は天候のみ変更値/3は馬場のみ変更値',
  `AtoTenkoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=現在状態_天候; column=AtoTenkoCD; table=S_TENKO_BABA; class=速報系; ref=code:2011; doc=12-3-39-TENKO_BABA',
  `AtoSibaBabaCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=現在状態_馬場(芝); column=AtoSibaBabaCD; table=S_TENKO_BABA; class=速報系; ref=code:2010; doc=12-3-39-TENKO_BABA',
  `AtoDirtBabaCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=現在状態_馬場(ダート); column=AtoDirtBabaCD; table=S_TENKO_BABA; class=速報系; ref=code:2010; doc=12-3-39-TENKO_BABA',
  `MaeTenkoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=変更前状態_天候; column=MaeTenkoCD; table=S_TENKO_BABA; class=速報系; ref=code:2011; doc=12-3-39-TENKO_BABA',
  `MaeSibaBabaCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=変更前状態_馬場(芝); column=MaeSibaBabaCD; table=S_TENKO_BABA; class=速報系; ref=code:2010; doc=12-3-39-TENKO_BABA',
  `MaeDirtBabaCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=変更前状態_馬場(ダート); column=MaeDirtBabaCD; table=S_TENKO_BABA; class=速報系; ref=code:2010; doc=12-3-39-TENKO_BABA',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`HappyoTime`,`HenkoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=天候馬場状態; table=S_TENKO_BABA; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
