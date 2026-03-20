-- Table structure for table `N_HANRO`
-- Table structure for table `N_HANRO`
--

DROP TABLE IF EXISTS `N_HANRO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_HANRO` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_HANRO; class=蓄積系; doc=12-3-37-HANRO; desc=HCでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_HANRO; class=蓄積系; doc=12-3-37-HANRO; desc=1:初期値 0:該当レコード削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_HANRO; class=蓄積系; unit=yyyymmdd; doc=12-3-37-HANRO; desc=西暦4桁+月日各2桁',
  `TresenKubun` varchar(1) NOT NULL COMMENT '[COL] name=トレセン区分; column=TresenKubun; table=N_HANRO; class=蓄積系; doc=12-3-37-HANRO; desc=0:美浦 1:栗東',
  `ChokyoDate` varchar(8) NOT NULL COMMENT '[COL] name=調教年月日; column=ChokyoDate; table=N_HANRO; class=蓄積系; unit=yyyymmdd; doc=12-3-37-HANRO',
  `ChokyoTime` varchar(4) NOT NULL COMMENT '[COL] name=調教時刻; column=ChokyoTime; table=N_HANRO; class=蓄積系; unit=hhmm; doc=12-3-37-HANRO; desc=時分各2桁',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=N_HANRO; class=蓄積系; doc=12-3-37-HANRO; desc=生年(西暦)4桁+品種1桁+数字5桁',
  `HaronTime4` varchar(4) DEFAULT NULL COMMENT '[COL] name=4ハロンタイム合計(800M～0M); column=HaronTime4; table=N_HANRO; class=蓄積系; unit=999.9秒; doc=12-3-37-HANRO; desc=測定不良時は0000をセット',
  `LapTime4` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(800M～600M); column=LapTime4; table=N_HANRO; class=蓄積系; unit=99.9秒; doc=12-3-37-HANRO; desc=測定不良時は000をセット',
  `HaronTime3` varchar(4) DEFAULT NULL COMMENT '[COL] name=3ハロンタイム合計(600M～0M); column=HaronTime3; table=N_HANRO; class=蓄積系; unit=999.9秒; doc=12-3-37-HANRO; desc=測定不良時は0000をセット',
  `LapTime3` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(600M～400M); column=LapTime3; table=N_HANRO; class=蓄積系; unit=99.9秒; doc=12-3-37-HANRO; desc=測定不良時は000をセット',
  `HaronTime2` varchar(4) DEFAULT NULL COMMENT '[COL] name=2ハロンタイム合計(400M～0M); column=HaronTime2; table=N_HANRO; class=蓄積系; unit=999.9秒; doc=12-3-37-HANRO; desc=測定不良時は0000をセット',
  `LapTime2` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(400M～200M); column=LapTime2; table=N_HANRO; class=蓄積系; unit=99.9秒; doc=12-3-37-HANRO; desc=測定不良時は000をセット',
  `LapTime1` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(200M～0M); column=LapTime1; table=N_HANRO; class=蓄積系; unit=99.9秒; doc=12-3-37-HANRO; desc=測定不良時は000をセット',
  PRIMARY KEY (`TresenKubun`,`ChokyoDate`,`ChokyoTime`,`KettoNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=坂路調教; table=N_HANRO; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
