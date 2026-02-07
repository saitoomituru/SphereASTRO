# Sleep Bake アルゴリズム仕様

## 目的
短期差分を安定記憶へ統合し、監査チェーンへ確定記録する。

## 入力
- 会話ログ列 `chat_messages`
- 睡眠前人格状態 `mitama_state_pre`
- 運用設定 `config_state`
- 未統合差分群 `transaction_fam_entries`
- 実行環境情報 `device_info`
- 依代許可設定 `engine_policy`
- 直前監査ハッシュ `prev_hash`

## 出力
- 統合結果ID `embedding_commit_id`
- 統合差分ハッシュ `diff_hash`
- 監査イベント `bake_event`
- 次監査ハッシュ `event_hash`

## 手順
1. 正規化
   1.1 `chat_messages`を時系列・改行・空白ルールで正規化する。  
   1.2 `mitama_state_pre`と`config_state`をキー順固定で正規化する。  
   1.3 `device_info`と`engine_policy`を監査項目のみ抽出して正規化する。  
2. ハッシュ化
   2.1 `chat_hash = Hash(chat_messages_normalized)`  
   2.2 `mitama_pre_hash = Hash(mitama_config_normalized)`  
   2.3 `device_hash = Hash(device_info_normalized)`  
   2.4 `engine_policy_hash = Hash(engine_policy_normalized)`  
3. 圧縮
   3.1 `transaction_fam_entries`を意味単位へクラスタリングする。  
   3.2 各クラスタから要約候補を生成する。  
   3.3 人格規範と衝突する候補を隔離キューへ退避する。  
4. 統合
   4.1 承認済み候補を安定記憶へ書き込む。  
   4.2 `embedding_commit_id`を発行する。  
   4.3 `diff_hash = Hash(integration_diff)`を計算する。  
5. 監査イベント生成
   5.1 `bake_event`へ以下を格納する。  
   - `prev_hash`  
   - `chat_hash`  
   - `mitama_pre_hash`  
   - `device_hash`  
   - `engine_policy_hash`  
   - `diff_hash`  
   - `embedding_commit_id`  
   - `timestamp`  
   - `bake_id`  
   5.2 `event_hash = Hash(bake_event)`を計算する。  
6. 追記
   6.1 監査台帳へ`bake_event`をappend-onlyで追記する。  
   6.2 追記失敗時は統合結果を無効化し、失敗イベントを記録する。  

## 擬似コード
```text
function sleepBake(input):
  n = normalize(input)
  hashes = computeHashes(n)
  candidates = compress(n.transaction_fam_entries)
  approved, quarantined = filterByMitamaPolicy(candidates)
  commit = integrateToEgoStore(approved)
  diff_hash = hash(commit.diff)
  event = buildBakeEvent(input.prev_hash, hashes, diff_hash, commit.id)
  event_hash = hash(event)
  appendAuditLedger(event, event_hash)
  return commit.id, diff_hash, event, event_hash
```

## 失敗時ポリシー
- 監査追記失敗時は成功応答を返さない。
- 統合途中失敗時はロールバックまたは再実行キューへ移送する。
- 隔離キューは手動審査対象として保持する。
