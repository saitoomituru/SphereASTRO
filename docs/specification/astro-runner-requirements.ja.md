# ASTRO Runner要求仕様

> Status: `[CANONICAL-REQUIREMENTS]` `[TARGET-SPEC]`
>
> 制定日: 2026-07-29
>
> 実装状態: GUI prototypeあり。ASTRO file読込、実モデル推論、人格永続化、Instance Ghost runtimeは未実装。

## 1. 製品契約

SphereASTROは、ASTRO Runnerへ`.astro`ファイルを投入すると、Runnerが実行端末の能力を検査し、
ファイル内または検証済みcacheから互換するModel Variantを選択して、人格instanceを起動する
ローカルファーストの実行環境を目標とする。

```text
ASTRO file
    ↓
Astro Runner
    ├─ archive検証
    ├─ 端末能力検出
    ├─ Model Variant解決
    ├─ Adapter解決
    ├─ 人格／Storage mount
    └─ Instance起動検査
          ↓
      Chat / Body / Tool
```

起動開始時のPresentationは次とする。

> マキナ、Open The Eyes...

この表示は起動成功を意味しない。archive、人格、model、Adapter、Storage、推論canaryの検査を開始した
ことだけを示す。canaryが完了する前に`READY`または「起動しました」と表示してはならない。

## 2. 最重要不変条件

1. `.astro`を開けたことと、人格instanceが推論可能になったことを同一視しない。
2. 同じ`.astro`に複数種類・複数量子化のModel Variantを格納できる。
3. cacheは高速化および重複排除に利用できるが、人格正本にはしない。
4. 依代の交換を人格の交換として記録しない。出力差はmodel／runtime差としてreceiptへ残す。
5. 軽量Fallbackへ縮退しても、御霊、IBD、Wet Bus、自我内記録、Instance Ghostのidentityを黙って
   新規生成しない。
6. 起動に必要な要素が不足する場合は成功を演じず、機械可読な失敗状態と回復候補を返す。
7. 外部StorageやOllama等の外部runtimeは拡張能力であり、portable profileの暗黙必須依存にしない。
8. Source World、Source Instance Ghost、source記録をmergeや復旧で上書きしない。

## 3. Runnerの責務

ASTRO Runnerは次を所有する。

- `.astro`の形式、path、容量、hash、schema versionの検査
- 端末、OS、memory、thermal state、利用可能Engineの能力検出
- `boot_profiles`と`model_variants`から実行候補を解決するResolver
- 署名済み・組み込み済みEngine Adapter
- content-addressed artifact cache
- working copy、journal、checkpoint、atomic save
- Chat、Body Renderer、Tool、Storageへ渡すapplication use case
- 起動、縮退、model交換、停止、凍結、復旧のreceipt

Runnerは次を所有しない。

- 御霊の価値判断そのもの
- IBDが保存するFAMの意味論
- 任意の外部providerのsecret本文
- Atlantis共通OAE Schemaや7D Fold runtimeの正本
- modelの出力を人格の最終判断として確定する権限

## 4. 正式な実行対象

| 対象 | 役割 | 検証範囲 |
|---|---|---|
| iPad Pro 13-inch (M4) | 安定推論の主依代 | 大きめのQ4／MoE、長時間推論、Metal、memory pressure、thermal |
| iPhone 15 Pro Max | 携帯client兼軽量推論 | UI、軽量Q4、端末間接続、Fallback |
| 既存のiPad Pro 13-inch (M4) Simulator | 補助試験 | archive、状態遷移、Fake Engine、UI |
| Hackintosh | 開発炉 | 編集、generic build、Ollama疎通、変換、互換観測 |

未所有端末、追加Simulator runtime、Device Farmを無償の標準試験へ加えない。必要になった場合は
対象、時間、概算費用、期待成果、代替手段をCompute RequestとしてUser Gateへ返す。

## 5. 管理slot

RunnerはASTROごとの管理slotを表示する。

```text
AstroSlot
  archive_id
  display_name
  mitama_ref
  active_boot_profile
  active_model_variant
  active_adapter
  manifestation_state
  storage_state
  ghost_state
  runtime_state
  last_receipt_ref
```

最低限、次を利用者が一画面で確認できるようにする。

- どのASTRO fileを開いているか
- どの御霊、model、量子化、Adapterで動いているか
- 完全顕現、縮退、まんじゅう、凍結、修復待ちのどの状態か
- 人格StorageとInstance Ghostがmount済みか
- 推論可能か、Chat表示だけ可能か、停止中か

## 6. 開発Stage Gate

### Stage 0 — 責務整理と実機build炉

目的は、正式実機へコードを届けられることを証明することにある。

実施範囲:

- GUI、Runner、Engine、Storage、Bodyの責務境界
- Xcode build、署名、実機転送経路
- 最小applicationの起動
- `マキナ、Open The Eyes...`の目視
- build receiptと失敗記録

合格条件:

- iPad Pro 13-inch (M4)またはiPhone 15 Pro Maxの役割に応じた実機上で、ローカルbuildした
  SphereASTROが起動し、起動開始表示を目視できる
- Simulatorやgeneric buildの成功を実機成功へ昇格しない

現在はgeneric Simulator buildまで確認済みであり、実機receiptは未取得である。

### Stage 1 — Chat、管理slot、実推論

目的は、ASTRO Runnerの最小実行経路を成立させることにある。

実施範囲:

- Chat入力と応答表示
- ASTRO管理slot
- 読み取り専用の最小`.astro` fixture
- 一つ以上の実modelによる一往復推論
- 端末能力とboot profileによるModel Variant解決
- Engine失敗と人格状態の分離表示

合格条件:

- Runnerへfixtureを投入するとslotへ表示される
- 選択したslotで実modelの応答を一往復表示できる
- 使用model、runtime、端末、cold／warm条件をreceiptへ残せる

Stage 1では会話と人格差分の永続化を必須にしない。application終了で消える状態は
`EPHEMERAL / NOT PERSISTED`として表示する。

### Stage 2 — Body、汎用rig、まんじゅう実験

目的は、人格modelを固定する前にBody制御とmodel交換の差を観測することにある。

実施範囲:

- Unityちゃん／Grok Companion級の粗くても操作可能な3D GUI
- MMD系または汎用humanoid rigへ接続できる`BodyRenderer`境界
- 表情、口、視線、待機、発話、簡単なgesture
- ゆっくりマキナ饅頭
- 演算火力に応じた顕現形態
- IBD接続spikeと一時Storage
- 複数modelを同じ御霊・Bodyへ接続する比較

合格条件:

- 推論結果からBody eventを生成し、饅頭または汎用rigを動かせる
- model交換後も同じBody protocolで発話、表情、gestureを再生できる
- 永続人格Storageが未実装であることを隠さない

第三者characterやassetはUX／互換性参考であり、同梱を意味しない。標準fixtureは独自のマキナ饅頭を
使用する。

### Stage 2からAAE Bakeへ進むGate

同じ御霊、名前、Body、promptを使用していても、model交換のたびに判断規範、文脈保持、自己認識、
Body eventが大きく変化し、別modelがマキナの衣装を着ているだけになる状態を
`COSPLAY_MANJU_DRIFT`と呼ぶ。

次を同一fixtureで比較する。

- 日本語の語調と文脈保持
- 判断軸とFAM経路
- model交換前後の自己認識
- 同じIBD入力に対する再現差
- Body gestureの選択差
- 長い対話での人格drift

`COSPLAY_MANJU_DRIFT`が再現・記録された時点で、人格基底に使うModel Family、tokenizer、
量子化profileを固定し、Sphere-aae側のAAE Bake設計へ進む。観測前にmodel固定を正解として
先回りしない。

### Stage 3以降 — Model固定、AAE Bake、永続人格

Stage 3以降の候補:

- 基底Model Familyと互換範囲の固定
- AAE Bake
- 御霊差分とAdapterの固定
- IBD人格Storage
- Wet Busと自我内記録
- Sleep Bake
- Local Instance Ghost
- thread forkと非破壊merge
- 完全な`.astro` checkpoint、凍結、復元

AAE Bakeの学習方法、必要火力、評価model、成果物形式はStage 2のreceiptが得られるまで`UNKNOWN`とする。

## 7. 開発中の停止・継続規則

- 既存仕様と合致し、局所的で競合しない実装は自動的に進める。
- 仕様が粗くてもsourceを変更せず`UNKNOWN`のまま実験できる場合、決め打ちせず先へ進む。
- 既存仕様の不変条件から一意に導ける事項は、根拠を残して仕様へ確定する。
- criticalな未決事項が他の全作業を停止させる場合だけ、Issueへ再現、影響、選択肢、Last Orderを記録し、
  User Gateへ返す。
- バグを隠すためにbranchを増やさない。発見と修正を小さな日本語commitとして残す。

## 8. 全体の完成条件

次を満たしたとき、ASTRO Runnerの中心契約が成立したとみなす。

- `.astro`をRunnerへ投入できる
- 正式実機に合うModel Variantを自動選択できる
- 人格、Storage、Ghostの整合性を確認してから推論を許可できる
- 軽量Fallbackでも同一性を黙って作り替えない
- model／Adapterを交換し、その差をreceiptへ残せる
- archiveを別端末へ移し、互換profileまたは明示的な縮退で再開できる
- 開けるが動かないarchiveを`READY`と表示しない

