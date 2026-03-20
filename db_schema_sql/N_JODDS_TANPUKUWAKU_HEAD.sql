-- Table structure for table `N_JODDS_TANPUKUWAKU_HEAD`
-- Table structure for table `N_JODDS_TANPUKUWAKU_HEAD`
--

DROP TABLE IF EXISTS `N_JODDS_TANPUKUWAKU_HEAD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_JODDS_TANPUKUWAKU_HEAD` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD; desc=O1でレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD; vals=1:中間 2:前日売最終 3:最終 4:確定 5:確定(月曜) 9:レース中止 0:削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=yyyymmdd; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=yyyy; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=mmdd; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; ref=code:2001; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `HappyoTime` varchar(8) NOT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=mmddhhmm; key=○; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD; note=中間オッズのみ設定／時系列オッズ使用時キー',
  `TorokuTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=登録頭数; column=TorokuTosu; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD; desc=出馬表発表時の登録頭数',
  `SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=出走頭数; column=SyussoTosu; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD; desc=登録頭数から出走取消・競走除外・発走除外を除いた頭数',
  `TansyoFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(単勝); column=TansyoFlag; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; vals=0/1/3/7; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `FukusyoFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(複勝); column=FukusyoFlag; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; vals=0/1/3/7; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `WakurenFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(枠連); column=WakurenFlag; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; vals=0/1/3/7; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `FukuChakuBaraiKey` varchar(1) DEFAULT NULL COMMENT '[COL] name=複勝着払キー; column=FukuChakuBaraiKey; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; vals=0:複勝発売なし 2:2着まで払い 3:3着まで払い; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `TotalHyosuTansyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=単勝票数合計; column=TotalHyosuTansyo; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=百円; note=返還分含む; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `TotalHyosuFukusyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=複勝票数合計; column=TotalHyosuFukusyo; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=百円; note=返還分含む; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  `TotalHyosuWakuren` varchar(11) DEFAULT NULL COMMENT '[COL] name=枠連票数合計; column=TotalHyosuWakuren; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=百円; note=返還分含む; doc=12-3-46-JODDS_TANPUKUWAKU_HEAD',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`,`HappyoTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=時系列オッズ_単複枠_ヘッダ; table=N_JODDS_TANPUKUWAKU_HEAD; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
