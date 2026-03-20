-- Table structure for table `S_UMA_RACE`
-- Table structure for table `S_UMA_RACE`
--

DROP TABLE IF EXISTS `S_UMA_RACE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `S_UMA_RACE` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=レコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=出走馬名表/出馬表/速報成績/成績などを区分',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=S_UMA_RACE; class=速報系; unit=yyyymmdd; doc=12-3-04-UMA_RACE; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=S_UMA_RACE; class=速報系; unit=yyyy; doc=12-3-04-UMA_RACE; desc=施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=S_UMA_RACE; class=速報系; unit=mmdd; doc=12-3-04-UMA_RACE; desc=施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=S_UMA_RACE; class=速報系; ref=code:2001; doc=12-3-04-UMA_RACE; desc=施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=同年同場での開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=該当レース番号',
  `Wakuban` varchar(1) DEFAULT NULL COMMENT '[COL] name=枠番; column=Wakuban; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=枠番号',
  `Umaban` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬番; column=Umaban; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=出馬表時点で確定',
  `KettoNum` varchar(10) NOT NULL COMMENT '[COL] name=血統登録番号; column=KettoNum; table=S_UMA_RACE; class=速報系; ref=code:2201; doc=12-3-04-UMA_RACE; desc=西暦4桁+品種1桁+数字5桁',
  `Bamei` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名; column=Bamei; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=全角18字(外国馬は混在あり)',
  `UmaKigoCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬記号コード; column=UmaKigoCD; table=S_UMA_RACE; class=速報系; ref=code:2204; doc=12-3-04-UMA_RACE; desc=記号コード',
  `SexCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=性別コード; column=SexCD; table=S_UMA_RACE; class=速報系; ref=code:2202; doc=12-3-04-UMA_RACE; desc=性別コード',
  `HinsyuCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=品種コード; column=HinsyuCD; table=S_UMA_RACE; class=速報系; ref=code:2201; doc=12-3-04-UMA_RACE; desc=品種コード',
  `KeiroCD` varchar(2) DEFAULT NULL COMMENT '[COL] name=毛色コード; column=KeiroCD; table=S_UMA_RACE; class=速報系; ref=code:2203; doc=12-3-04-UMA_RACE; desc=毛色コード',
  `Barei` varchar(2) DEFAULT NULL COMMENT '[COL] name=馬齢; column=Barei; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=2000年以前:数え年/2001年以降:満年齢',
  `TozaiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=東西所属コード; column=TozaiCD; table=S_UMA_RACE; class=速報系; ref=code:2301; doc=12-3-04-UMA_RACE; desc=東西所属',
  `ChokyosiCode` varchar(5) DEFAULT NULL COMMENT '[COL] name=調教師コード; column=ChokyosiCode; table=S_UMA_RACE; class=速報系; ref=N_CHOKYO(ChokyosiCode); doc=12-3-04-UMA_RACE; desc=調教師マスタ参照',
  `ChokyosiRyakusyo` varchar(8) DEFAULT NULL COMMENT '[COL] name=調教師名略称; column=ChokyosiRyakusyo; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=全角4字略称',
  `BanusiCode` varchar(6) DEFAULT NULL COMMENT '[COL] name=馬主コード; column=BanusiCode; table=S_UMA_RACE; class=速報系; ref=N_BANUSI(BanusiCode); doc=12-3-04-UMA_RACE; desc=馬主マスタ参照',
  `BanusiName` varchar(64) DEFAULT NULL COMMENT '[COL] name=馬主名; column=BanusiName; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=法人格等を除いた名称',
  `Fukusyoku` varchar(60) DEFAULT NULL COMMENT '[COL] name=服色標示; column=Fukusyoku; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=勝負服の色・模様',
  `reserved1` varchar(60) DEFAULT NULL COMMENT '[COL] name=予備1; column=reserved1; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=将来拡張/予備',
  `Futan` varchar(3) DEFAULT NULL COMMENT '[COL] name=負担重量; column=Futan; table=S_UMA_RACE; class=速報系; unit=0.1kg; doc=12-3-04-UMA_RACE; desc=負担重量',
  `FutanBefore` varchar(3) DEFAULT NULL COMMENT '[COL] name=変更前負担重量; column=FutanBefore; table=S_UMA_RACE; class=速報系; unit=0.1kg; doc=12-3-04-UMA_RACE; desc=変更前の負担重量',
  `Blinker` varchar(1) DEFAULT NULL COMMENT '[COL] name=ブリンカー使用区分; column=Blinker; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=0未使用/1使用',
  `reserved2` varchar(1) DEFAULT NULL COMMENT '[COL] name=予備2; column=reserved2; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=将来拡張/予備',
  `KisyuCode` varchar(5) DEFAULT NULL COMMENT '[COL] name=騎手コード; column=KisyuCode; table=S_UMA_RACE; class=速報系; ref=N_KISYU(KisyuCode); doc=12-3-04-UMA_RACE; desc=騎手マスタ参照',
  `KisyuCodeBefore` varchar(5) DEFAULT NULL COMMENT '[COL] name=変更前騎手コード; column=KisyuCodeBefore; table=S_UMA_RACE; class=速報系; ref=N_KISYU(KisyuCode); doc=12-3-04-UMA_RACE; desc=変更前の騎手コード',
  `KisyuRyakusyo` varchar(8) DEFAULT NULL COMMENT '[COL] name=騎手名略称; column=KisyuRyakusyo; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=全角4字略称',
  `KisyuRyakusyoBefore` varchar(8) DEFAULT NULL COMMENT '[COL] name=変更前騎手名略称; column=KisyuRyakusyoBefore; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=変更前の略称',
  `MinaraiCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=騎手見習コード; column=MinaraiCD; table=S_UMA_RACE; class=速報系; ref=code:2303; doc=12-3-04-UMA_RACE; desc=見習コード',
  `MinaraiCDBefore` varchar(1) DEFAULT NULL COMMENT '[COL] name=変更前騎手見習コード; column=MinaraiCDBefore; table=S_UMA_RACE; class=速報系; ref=code:2303; doc=12-3-04-UMA_RACE; desc=変更前の見習コード',
  `BaTaijyu` varchar(3) DEFAULT NULL COMMENT '[COL] name=馬体重; column=BaTaijyu; table=S_UMA_RACE; class=速報系; unit=kg; doc=12-3-04-UMA_RACE; desc=002～998kg/999計量不能/000取消',
  `ZogenFugo` varchar(1) DEFAULT NULL COMMENT '[COL] name=増減符号; column=ZogenFugo; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=+増/-減/空白その他',
  `ZogenSa` varchar(3) DEFAULT NULL COMMENT '[COL] name=増減差; column=ZogenSa; table=S_UMA_RACE; class=速報系; unit=kg; doc=12-3-04-UMA_RACE; desc=001～998/999計量不能/000前差なし',
  `IJyoCD` varchar(1) DEFAULT NULL COMMENT '[COL] name=異常区分コード; column=IJyoCD; table=S_UMA_RACE; class=速報系; ref=code:2101; doc=12-3-04-UMA_RACE; desc=出走取消･中止等',
  `NyusenJyuni` varchar(2) DEFAULT NULL COMMENT '[COL] name=入線順位; column=NyusenJyuni; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=失格/降着確定前の順位',
  `KakuteiJyuni` varchar(2) DEFAULT NULL COMMENT '[COL] name=確定着順; column=KakuteiJyuni; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=失格/降着後の確定順位',
  `DochakuKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=同着区分; column=DochakuKubun; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=0無し/1あり',
  `DochakuTosu` varchar(1) DEFAULT NULL COMMENT '[COL] name=同着頭数; column=DochakuTosu; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=自身以外の同着頭数',
  `Time` varchar(4) DEFAULT NULL COMMENT '[COL] name=走破タイム; column=Time; table=S_UMA_RACE; class=速報系; unit=分秒; doc=12-3-04-UMA_RACE; desc=9分99秒9で設定',
  `ChakusaCD` varchar(3) DEFAULT NULL COMMENT '[COL] name=着差コード; column=ChakusaCD; table=S_UMA_RACE; class=速報系; ref=code:2102; doc=12-3-04-UMA_RACE; desc=前馬との着差',
  `ChakusaCDP` varchar(3) DEFAULT NULL COMMENT '[COL] name=＋着差コード; column=ChakusaCDP; table=S_UMA_RACE; class=速報系; ref=code:2102; doc=12-3-04-UMA_RACE; desc=前馬と前の前馬の差',
  `ChakusaCDPP` varchar(3) DEFAULT NULL COMMENT '[COL] name=＋＋着差コード; column=ChakusaCDPP; table=S_UMA_RACE; class=速報系; ref=code:2102; doc=12-3-04-UMA_RACE; desc=前の前馬２頭の差',
  `Jyuni1c` varchar(2) DEFAULT NULL COMMENT '[COL] name=1コーナー順位; column=Jyuni1c; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=1角の通過順位',
  `Jyuni2c` varchar(2) DEFAULT NULL COMMENT '[COL] name=2コーナー順位; column=Jyuni2c; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=2角の通過順位',
  `Jyuni3c` varchar(2) DEFAULT NULL COMMENT '[COL] name=3コーナー順位; column=Jyuni3c; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=3角の通過順位',
  `Jyuni4c` varchar(2) DEFAULT NULL COMMENT '[COL] name=4コーナー順位; column=Jyuni4c; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=4角の通過順位',
  `Odds` varchar(4) DEFAULT NULL COMMENT '[COL] name=単勝オッズ; column=Odds; table=S_UMA_RACE; class=速報系; unit=倍; doc=12-3-04-UMA_RACE; desc=999.9倍まで',
  `Ninki` varchar(2) DEFAULT NULL COMMENT '[COL] name=単勝人気順; column=Ninki; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=人気順(出走取消等は初期値)',
  `Honsyokin` varchar(8) DEFAULT NULL COMMENT '[COL] name=獲得本賞金; column=Honsyokin; table=S_UMA_RACE; class=速報系; unit=百円; doc=12-3-04-UMA_RACE; desc=当該レースの本賞金',
  `Fukasyokin` varchar(8) DEFAULT NULL COMMENT '[COL] name=獲得付加賞金; column=Fukasyokin; table=S_UMA_RACE; class=速報系; unit=百円; doc=12-3-04-UMA_RACE; desc=当該レースの付加賞金',
  `reserved3` varchar(3) DEFAULT NULL COMMENT '[COL] name=予備3; column=reserved3; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=将来拡張/予備',
  `reserved4` varchar(3) DEFAULT NULL COMMENT '[COL] name=予備4; column=reserved4; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=将来拡張/予備',
  `HaronTimeL4` varchar(3) DEFAULT NULL COMMENT '[COL] name=後4ハロンタイム; column=HaronTimeL4; table=S_UMA_RACE; class=速報系; unit=秒; doc=12-3-04-UMA_RACE; desc=99.9秒(状況により初期値)',
  `HaronTimeL3` varchar(3) DEFAULT NULL COMMENT '[COL] name=後3ハロンタイム; column=HaronTimeL3; table=S_UMA_RACE; class=速報系; unit=秒; doc=12-3-04-UMA_RACE; desc=99.9秒(障害は1F平均等)',
  `KettoNum1` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号(相手馬1); column=KettoNum1; table=S_UMA_RACE; class=速報系; ref=code:2201; doc=12-3-04-UMA_RACE; desc=1頭目',
  `Bamei1` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名(相手馬1); column=Bamei1; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=1頭目の馬名',
  `KettoNum2` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号(相手馬2); column=KettoNum2; table=S_UMA_RACE; class=速報系; ref=code:2201; doc=12-3-04-UMA_RACE; desc=2頭目',
  `Bamei2` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名(相手馬2); column=Bamei2; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=2頭目の馬名',
  `KettoNum3` varchar(10) DEFAULT NULL COMMENT '[COL] name=血統登録番号(相手馬3); column=KettoNum3; table=S_UMA_RACE; class=速報系; ref=code:2201; doc=12-3-04-UMA_RACE; desc=3頭目',
  `Bamei3` varchar(36) DEFAULT NULL COMMENT '[COL] name=馬名(相手馬3); column=Bamei3; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=3頭目の馬名',
  `TimeDiff` varchar(4) DEFAULT NULL,
  `RecordUpKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=レコード更新区分; column=RecordUpKubun; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=0初期/1基準タイム/2コースレコード更新',
  `DMKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=マイニング区分; column=DMKubun; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=1前日/2当日/3直前',
  `DMTime` varchar(5) DEFAULT NULL COMMENT '[COL] name=マイニング予想走破タイム; column=DMTime; table=S_UMA_RACE; class=速報系; unit=分秒; doc=12-3-04-UMA_RACE; desc=9分99秒99で設定',
  `DMGosaP` varchar(4) DEFAULT NULL COMMENT '[COL] name=予想誤差(＋); column=DMGosaP; table=S_UMA_RACE; class=速報系; unit=秒; doc=12-3-04-UMA_RACE; desc=早くなる方向の誤差(マイナス適用)',
  `DMGosaM` varchar(4) DEFAULT NULL COMMENT '[COL] name=予想誤差(－); column=DMGosaM; table=S_UMA_RACE; class=速報系; unit=秒; doc=12-3-04-UMA_RACE; desc=遅くなる方向の誤差(プラス適用)',
  `DMJyuni` varchar(2) DEFAULT NULL COMMENT '[COL] name=マイニング予想順位; column=DMJyuni; table=S_UMA_RACE; class=速報系; unit=位; doc=12-3-04-UMA_RACE; desc=01～18位',
  `KyakusituKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=今回レース脚質判定; column=KyakusituKubun; table=S_UMA_RACE; class=速報系; doc=12-3-04-UMA_RACE; desc=1逃/2先/3差/4追/0初期値',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`KettoNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[S] name=馬毎レース情報; table=S_UMA_RACE; class=速報系';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-06 20:18:44
