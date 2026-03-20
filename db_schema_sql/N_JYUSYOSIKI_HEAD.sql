-- Table structure for table `N_JYUSYOSIKI_HEAD`
-- Table structure for table `N_JYUSYOSIKI_HEAD`
--

DROP TABLE IF EXISTS `N_JYUSYOSIKI_HEAD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_JYUSYOSIKI_HEAD` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=WFでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; vals=1:重勝式詳細発表 2:対象1R確定 3:払戻発表 7:成績(月曜)[蓄積系のみ] 9:中止 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_JYUSYOSIKI_HEAD; class=蓄積系; unit=yyyymmdd; doc=12-3-56-JYUSYOSIKI_HEAD',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_JYUSYOSIKI_HEAD; class=蓄積系; unit=yyyy; key=○; doc=12-3-56-JYUSYOSIKI_HEAD',
  `MonthDay` varchar(4) NOT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_JYUSYOSIKI_HEAD; class=蓄積系; unit=mmdd; key=○; doc=12-3-56-JYUSYOSIKI_HEAD',
  `reserved1` varchar(2) DEFAULT NULL COMMENT '[COL] name=予備1; column=reserved1; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD',
  `JyoCD1` varchar(2) DEFAULT NULL COMMENT '[COL] name=競馬場コード1; column=JyoCD1; table=N_JYUSYOSIKI_HEAD; class=蓄積系; ref=code:2001; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象1レース施行競馬場',
  `Kaiji1` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催回1; column=Kaiji1; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象1レース施行回(同年同場での第N回)',
  `Nichiji1` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催日目1; column=Nichiji1; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象1レース施行日目',
  `RaceNum1` varchar(2) DEFAULT NULL COMMENT '[COL] name=レース番号1; column=RaceNum1; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象1レース番号',
  `JyoCD2` varchar(2) DEFAULT NULL COMMENT '[COL] name=競馬場コード2; column=JyoCD2; table=N_JYUSYOSIKI_HEAD; class=蓄積系; ref=code:2001; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象2レース施行競馬場',
  `Kaiji2` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催回2; column=Kaiji2; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象2レース施行回(同年同場での第N回)',
  `Nichiji2` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催日目2; column=Nichiji2; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象2レース施行日目',
  `RaceNum2` varchar(2) DEFAULT NULL COMMENT '[COL] name=レース番号2; column=RaceNum2; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象2レース番号',
  `JyoCD3` varchar(2) DEFAULT NULL COMMENT '[COL] name=競馬場コード3; column=JyoCD3; table=N_JYUSYOSIKI_HEAD; class=蓄積系; ref=code:2001; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象3レース施行競馬場',
  `Kaiji3` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催回3; column=Kaiji3; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象3レース施行回(同年同場での第N回)',
  `Nichiji3` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催日目3; column=Nichiji3; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象3レース施行日目',
  `RaceNum3` varchar(2) DEFAULT NULL COMMENT '[COL] name=レース番号3; column=RaceNum3; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象3レース番号',
  `JyoCD4` varchar(2) DEFAULT NULL COMMENT '[COL] name=競馬場コード4; column=JyoCD4; table=N_JYUSYOSIKI_HEAD; class=蓄積系; ref=code:2001; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象4レース施行競馬場',
  `Kaiji4` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催回4; column=Kaiji4; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象4レース施行回(同年同場での第N回)',
  `Nichiji4` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催日目4; column=Nichiji4; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象4レース施行日目',
  `RaceNum4` varchar(2) DEFAULT NULL COMMENT '[COL] name=レース番号4; column=RaceNum4; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象4レース番号',
  `JyoCD5` varchar(2) DEFAULT NULL COMMENT '[COL] name=競馬場コード5; column=JyoCD5; table=N_JYUSYOSIKI_HEAD; class=蓄積系; ref=code:2001; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象5レース施行競馬場',
  `Kaiji5` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催回5; column=Kaiji5; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象5レース施行回(同年同場での第N回)',
  `Nichiji5` varchar(2) DEFAULT NULL COMMENT '[COL] name=開催日目5; column=Nichiji5; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象5レース施行日目',
  `RaceNum5` varchar(2) DEFAULT NULL COMMENT '[COL] name=レース番号5; column=RaceNum5; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象5レース番号',
  `reserved2` varchar(6) DEFAULT NULL COMMENT '[COL] name=予備2; column=reserved2; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD',
  `Hatsubai_Hyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=重勝式発売票数; column=Hatsubai_Hyo; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD',
  `YukoHyosu1` varchar(11) DEFAULT NULL COMMENT '[COL] name=有効票数1; column=YukoHyosu1; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象1レース確定時点で的中可能性が残る票数',
  `YukoHyosu2` varchar(11) DEFAULT NULL COMMENT '[COL] name=有効票数2; column=YukoHyosu2; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象2レース確定時点で的中可能性が残る票数',
  `YukoHyosu3` varchar(11) DEFAULT NULL COMMENT '[COL] name=有効票数3; column=YukoHyosu3; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象3レース確定時点で的中可能性が残る票数',
  `YukoHyosu4` varchar(11) DEFAULT NULL COMMENT '[COL] name=有効票数4; column=YukoHyosu4; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象4レース確定時点で的中可能性が残る票数',
  `YukoHyosu5` varchar(11) DEFAULT NULL COMMENT '[COL] name=有効票数5; column=YukoHyosu5; table=N_JYUSYOSIKI_HEAD; class=蓄積系; doc=12-3-56-JYUSYOSIKI_HEAD; desc=対象5レース確定時点で的中可能性が残る票数',
  `HenkanFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還フラグ; column=HenkanFlag; table=N_JYUSYOSIKI_HEAD; class=蓄積系; vals=0:返還無 1:返還有; doc=12-3-56-JYUSYOSIKI_HEAD',
  `FuseirituFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=不成立フラグ; column=FuseirituFlag; table=N_JYUSYOSIKI_HEAD; class=蓄積系; vals=0:不成立無 1:不成立有; doc=12-3-56-JYUSYOSIKI_HEAD',
  `TekichunashiFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=的中無フラグ; column=TekichunashiFlag; table=N_JYUSYOSIKI_HEAD; class=蓄積系; vals=0:的中有 1:的中無; doc=12-3-56-JYUSYOSIKI_HEAD',
  `CarryoverSyoki` varchar(15) DEFAULT NULL COMMENT '[COL] name=キャリーオーバー金額初期; column=CarryoverSyoki; table=N_JYUSYOSIKI_HEAD; class=蓄積系; unit=円; doc=12-3-56-JYUSYOSIKI_HEAD; desc=開催日当日開始時の金額',
  `CarryoverZandaka` varchar(15) DEFAULT NULL COMMENT '[COL] name=キャリーオーバー金額残高; column=CarryoverZandaka; table=N_JYUSYOSIKI_HEAD; class=蓄積系; unit=円; doc=12-3-56-JYUSYOSIKI_HEAD; desc=次回への金額',
  PRIMARY KEY (`Year`,`MonthDay`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=重勝式_ヘッダ; table=N_JYUSYOSIKI_HEAD; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
