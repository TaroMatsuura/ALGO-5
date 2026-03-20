-- Table structure for table `N_HYOSU2`
-- Table structure for table `N_HYOSU2`
--

DROP TABLE IF EXISTS `N_HYOSU2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_HYOSU2` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=H6でレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=2前日売最終/4確定/5確定(月)/9中止/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_HYOSU2; class=蓄積系; unit=yyyymmdd; doc=12-3-12-HYOSU2; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_HYOSU2; class=蓄積系; unit=yyyy; doc=12-3-12-HYOSU2; desc=施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_HYOSU2; class=蓄積系; unit=mmdd; doc=12-3-12-HYOSU2; desc=施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_HYOSU2; class=蓄積系; ref=code:2001; doc=12-3-12-HYOSU2; desc=施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=該当レース番号',
  `TorokuTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=登録頭数; column=TorokuTosu; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=出馬表発表時の登録頭数',
  `SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=出走頭数; column=SyussoTosu; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=取消･除外反映後の出走頭数',
  `HatubaiFlag1` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(3連単); column=HatubaiFlag1; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=0発売なし/1発売前取消/3発売後取消/7発売あり',
  `HenkanUma1` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報1; column=HenkanUma1; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma2` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報2; column=HenkanUma2; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma3` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報3; column=HenkanUma3; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma4` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報4; column=HenkanUma4; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma5` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報5; column=HenkanUma5; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma6` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報6; column=HenkanUma6; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma7` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報7; column=HenkanUma7; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma8` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報8; column=HenkanUma8; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma9` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報9; column=HenkanUma9; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma10` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報10; column=HenkanUma10; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma11` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報11; column=HenkanUma11; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma12` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報12; column=HenkanUma12; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma13` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報13; column=HenkanUma13; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma14` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報14; column=HenkanUma14; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma15` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報15; column=HenkanUma15; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma16` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報16; column=HenkanUma16; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma17` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報17; column=HenkanUma17; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HenkanUma18` varchar(1) DEFAULT NULL COMMENT '[COL] name=返還馬番情報18; column=HenkanUma18; table=N_HYOSU2; class=蓄積系; doc=12-3-12-HYOSU2; desc=返還対象馬番ビット列(該当=1)',
  `HyoTotal1` varchar(11) DEFAULT NULL COMMENT '[COL] name=3連単票数合計; column=HyoTotal1; table=N_HYOSU2; class=蓄積系; unit=百円; doc=12-3-12-HYOSU2; desc=返還分を含む合計票数',
  `HyoTotal2` varchar(11) DEFAULT NULL COMMENT '[COL] name=3連単返還票数合計; column=HyoTotal2; table=N_HYOSU2; class=蓄積系; unit=百円; doc=12-3-12-HYOSU2; desc=返還票数合計(差引で有効票数)',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=票数2; table=N_HYOSU2; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
