-- Table structure for table `N_WOOD_CHIP`
-- Table structure for table `N_WOOD_CHIP`
--

DROP TABLE IF EXISTS `N_WOOD_CHIP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_WOOD_CHIP` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; desc=WCでレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; vals=1:初期値 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_WOOD_CHIP; class=蓄積系; unit=yyyymmdd; doc=12-3-59-WOOD_CHIP',
  `TresenKubun` varchar(1) NOT NULL COMMENT '[COL] name=トレセン区分; column=TresenKubun; table=N_WOOD_CHIP; class=蓄積系; key=○; doc=12-3-59-WOOD_CHIP; vals=0:美浦 1:栗東',
  `ChokyoDate` varchar(8) NOT NULL COMMENT '[COL] name=調教年月日; column=ChokyoDate; table=N_WOOD_CHIP; class=蓄積系; key=○; unit=yyyymmdd; doc=12-3-59-WOOD_CHIP',
  `ChokyoTime` varchar(4) NOT NULL COMMENT '[COL] name=調教時刻; column=ChokyoTime; table=N_WOOD_CHIP; class=蓄積系; key=○; unit=hhmm; doc=12-3-59-WOOD_CHIP; desc=時分各2桁',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=N_WOOD_CHIP; class=蓄積系; key=○; doc=12-3-59-WOOD_CHIP; desc=生年4桁+品種1桁+連番5桁',
  `Course` varchar(1) DEFAULT NULL COMMENT '[COL] name=コース; column=Course; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; vals=0:A|1:B|2:C|3:D|4:E',
  `BabaAround` varchar(1) DEFAULT NULL COMMENT '[COL] name=馬場周り; column=BabaAround; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; vals=0:右|1:左',
  `reserved` varchar(1) DEFAULT NULL COMMENT '[COL] name=予備; column=reserved; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP',
  `HaronTime10` varchar(4) DEFAULT NULL COMMENT '[COL] name=10ハロンタイム合計(2000M～0M); column=HaronTime10; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime10` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(2000M～1800M); column=LapTime10; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime9` varchar(4) DEFAULT NULL COMMENT '[COL] name=9ハロンタイム合計(1800M～0M); column=HaronTime9; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime9` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(1800M～1600M); column=LapTime9; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime8` varchar(4) DEFAULT NULL COMMENT '[COL] name=8ハロンタイム合計(1600M～0M); column=HaronTime8; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime8` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(1600M～1400M); column=LapTime8; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime7` varchar(4) DEFAULT NULL COMMENT '[COL] name=7ハロンタイム合計(1400M～0M); column=HaronTime7; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime7` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(1400M～1200M); column=LapTime7; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime6` varchar(4) DEFAULT NULL COMMENT '[COL] name=6ハロンタイム合計(1200M～0M); column=HaronTime6; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime6` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(1200M～1000M); column=LapTime6; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime5` varchar(4) DEFAULT NULL COMMENT '[COL] name=5ハロンタイム合計(1000M～0M); column=HaronTime5; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime5` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(1000M～800M); column=LapTime5; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime4` varchar(4) DEFAULT NULL COMMENT '[COL] name=4ハロンタイム合計(800M～0M); column=HaronTime4; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime4` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(800M～600M); column=LapTime4; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime3` varchar(4) DEFAULT NULL COMMENT '[COL] name=3ハロンタイム合計(600M～0M); column=HaronTime3; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime3` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(600M～400M); column=LapTime3; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `HaronTime2` varchar(4) DEFAULT NULL COMMENT '[COL] name=2ハロンタイム合計(400M～0M); column=HaronTime2; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=999.9; special=測定不良:0000|上限超:9999',
  `LapTime2` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(400M～200M); column=LapTime2; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  `LapTime1` varchar(3) DEFAULT NULL COMMENT '[COL] name=ラップタイム(200M～0M); column=LapTime1; table=N_WOOD_CHIP; class=蓄積系; doc=12-3-59-WOOD_CHIP; unit=秒; format=99.9; special=測定不良:000|上限超:999',
  PRIMARY KEY (`TresenKubun`,`ChokyoDate`,`ChokyoTime`,`KettoNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=ウッドチップ調教; table=N_WOOD_CHIP; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
