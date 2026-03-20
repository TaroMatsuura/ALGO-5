-- Table structure for table `N_ODDS_TANPUKUWAKU_HEAD`
-- Table structure for table `N_ODDS_TANPUKUWAKU_HEAD`
--

DROP TABLE IF EXISTS `N_ODDS_TANPUKUWAKU_HEAD`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `N_ODDS_TANPUKUWAKU_HEAD` (
  `RecordSpec` varchar(2) DEFAULT NULL COMMENT '[COL] name=レコード種別ID; column=RecordSpec; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=O1でレコード形式を識別',
  `DataKubun` varchar(1) DEFAULT NULL COMMENT '[COL] name=データ区分; column=DataKubun; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=1中間/2前日売最終/3最終/4確定/5確定(月)/9中止/0削除',
  `MakeDate` varchar(8) DEFAULT NULL COMMENT '[COL] name=データ作成年月日; column=MakeDate; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=yyyymmdd; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=作成日(西暦8桁)',
  `Year` varchar(4) NOT NULL COMMENT '[COL] name=開催年; column=Year; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=yyyy; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=該当レース施行年',
  `MonthDay` varchar(4) DEFAULT NULL COMMENT '[COL] name=開催月日; column=MonthDay; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=mmdd; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=該当レース施行月日',
  `JyoCD` varchar(2) NOT NULL COMMENT '[COL] name=競馬場コード; column=JyoCD; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; ref=code:2001; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=該当レース施行競馬場コード',
  `Kaiji` varchar(2) NOT NULL COMMENT '[COL] name=開催回; column=Kaiji; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=同年同場の開催回',
  `Nichiji` varchar(2) NOT NULL COMMENT '[COL] name=開催日目; column=Nichiji; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=開催回内の日目',
  `RaceNum` varchar(2) NOT NULL COMMENT '[COL] name=レース番号; column=RaceNum; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=該当レース番号',
  `HappyoTime` varchar(8) DEFAULT NULL COMMENT '[COL] name=発表月日時分; column=HappyoTime; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=mmddHHMM; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=中間オッズのみ設定/時系列オッズ使用時はキー',
  `TorokuTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=登録頭数; column=TorokuTosu; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=出馬表発表時の登録頭数',
  `SyussoTosu` varchar(2) DEFAULT NULL COMMENT '[COL] name=出走頭数; column=SyussoTosu; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=取消･除外反映後の出走頭数',
  `TansyoFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(単勝); column=TansyoFlag; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=0発売なし/1発売前取消/3発売後取消/7発売あり',
  `FukusyoFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(複勝); column=FukusyoFlag; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=0発売なし/1発売前取消/3発売後取消/7発売あり',
  `WakurenFlag` varchar(1) DEFAULT NULL COMMENT '[COL] name=発売フラグ(枠連); column=WakurenFlag; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=0発売なし/1発売前取消/3発売後取消/7発売あり',
  `FukuChakuBaraiKey` varchar(1) DEFAULT NULL COMMENT '[COL] name=複勝着払キー; column=FukuChakuBaraiKey; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=0複勝発売なし/2:2着まで払い/3:3着まで払い',
  `TotalHyosuTansyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=単勝票数合計; column=TotalHyosuTansyo; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=百円; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=返還分票数を含む合計',
  `TotalHyosuFukusyo` varchar(11) DEFAULT NULL COMMENT '[COL] name=複勝票数合計; column=TotalHyosuFukusyo; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=百円; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=返還分票数を含む合計',
  `TotalHyosuWakuren` varchar(11) DEFAULT NULL COMMENT '[COL] name=枠連票数合計; column=TotalHyosuWakuren; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系; unit=百円; doc=12-3-14-ODDS_TANPUKUWAKU_HEAD; desc=返還分票数を含む合計',
  PRIMARY KEY (`Year`,`JyoCD`,`Kaiji`,`Nichiji`,`RaceNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='[N] name=オッズ_単複枠_ヘッダ; table=N_ODDS_TANPUKUWAKU_HEAD; class=蓄積系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
