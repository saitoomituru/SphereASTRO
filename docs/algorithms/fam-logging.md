# FAM Logging アルゴリズム仕様

## 目的
判断経路を再現可能に記録し、責任境界の検証を可能にする。

## 入力
- セッションID `session_id`
- 観測入力 `observation`
- 文脈情報 `context`
- 判断結果 `decision`
- 出力結果 `expression`
- 実行依代情報 `engine_meta`

## 出力
- ログイベント `fam_log_event`
- イベントハッシュ `fam_log_hash`

## ログレコード構造
- `session_id`
- `step_id`
- `phase`（observation/contextualization/decision/expression）
- `input_ref`
- `policy_ref`
- `output_ref`
- `engine_ref`
- `timestamp`
- `prev_log_hash`

## 手順
1. Phase分割
   - 1対話ターンを4phaseへ分割する。
2. 参照化
   - 生データは直接格納せず、保存先参照IDを記録する。
3. 正規化
   - レコードをキー順固定、時刻形式固定で整形する。
4. ハッシュ化
   - `fam_log_hash = Hash(normalized_record + prev_log_hash)`を計算する。
5. 保存
   - イベントストアへ追記し、`prev_log_hash`を更新する。

## 擬似コード
```text
function logFAMTurn(turn):
  prev = loadPrevLogHash(turn.session_id)
  for phase in [observation, contextualization, decision, expression]:
    record = buildPhaseRecord(turn, phase, prev)
    normalized = normalize(record)
    current = hash(normalized + prev)
    appendLog(record, current)
    prev = current
  return prev
```

## 運用規則
- ログは削除せず失効フラグで管理する。
- 監査時はphase単位で再生する。
- 依代変更があった場合、phase開始時に必ず記録する。
