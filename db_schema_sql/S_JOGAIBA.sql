-- Table structure for table `S_JOGAIBA`
-- Table structure for table `S_JOGAIBA`
--

DROP TABLE IF EXISTS `S_JOGAIBA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_JOGAIBA` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_JOGAIBA; class=速報系; doc=12-3-58-JOGAIBA; desc=JGでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_JOGAIBA; class=速報系; doc=12-3-58-JOGAIBA; vals=1:初期値 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_JOGAIBA; class=速報系; unit=yyyymmdd; doc=12-3-58-JOGAIBA; desc=西暦4桁+月日各2桁',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_JOGAIBA; class=速報系; unit=yyyy; key=○; doc=12-3-58-JOGAIBA',
  `MonthDay` varchar(4) NOT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_JOGAIBA; class=速報系; unit=mmdd; key=○; doc=12-3-58-JOGAIBA',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_JOGAIBA; class=速報系; ref=code:2001; key=○; doc=12-3-58-JOGAIBA; desc=施行競馬場',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_JOGAIBA; class=速報系; key=○; doc=12-3-58-JOGAIBA; desc=同年同場での第N回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_JOGAIBA; class=速報系; key=○; doc=12-3-58-JOGAIBA; desc=開催回内のN日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_JOGAIBA; class=速報系; key=○; doc=12-3-58-JOGAIBA',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=S_JOGAIBA; class=速報系; key=○; doc=12-3-58-JOGAIBA; desc=生年4桁+品種1桁+連番5桁; link=競走馬マスタ',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=S_JOGAIBA; class=速報系; unit=全角18; doc=12-3-58-JOGAIBA',
  `ShutsubaTohyoJun` varchar(3) NOT NULL COMMENT '[COL] name=出馬投票受付順番; column=ShutsubaTohyoJun; table=S_JOGAIBA; class=速報系; key=○; doc=12-3-58-JOGAIBA; desc=同一業務日付で同一馬を受付(追加/再投票)した順序',
  `ShussoKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=出走区分; column=ShussoKubun; table=S_JOGAIBA; class=速報系; doc=12-3-58-JOGAIBA; vals=1:投票馬 2:締切での除外馬 4:再投票馬 5:再投票除外馬 6:馬番無しの出走取消馬 9:取消馬',
  `JogaiJotaiKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=除外状態区分; column=JogaiJotaiKubun; table=S_JOGAIBA; class=速報系; doc=12-3-58-JOGAIBA; vals=1:非抽選馬 2:非当選馬',
  PRIMARY KEY (`Year`,`MonthDay`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`KettoNum`,`ShutsubaTohyoJun`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=競走馬除外情報; table=S_JOGAIBA; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
