# ASTROファイル形式

> Status: `[DRAFT-SPECIFICATION]` `[NOT-IMPLEMENTED]`
>
> 制定日: 2026-07-29
>
> 拡張子: `.astro`

## 1. 目的

`.astro`は、ASTRO Runnerへ渡すと人格instanceを組み立てられるZIP／ZIP64ベースの可搬packageである。
単なるprompt JSONや外部Storageへのshortcutにしない。起動に必要な情報が複数の端末、cache、設定folderへ
散らばり、ASTRO fileだけを開いても実行できない事故を最優先で防ぐ。

一つの`.astro`には複数種類、複数量子化、複数端末向けのModel Variantを格納できる。Runnerは
archive、端末内cache、組み込みEngineの能力を照合し、最も優先度の高い互換profileを選択する。

## 2. package構造

```text
Makina.astro
├─ manifest.json
├─ boot/
│  ├─ profiles.json
│  └─ resource-requirements.json
├─ persona/
│  ├─ mitama.json
│  ├─ aramitama.json
│  ├─ fam-profile.json
│  └─ prompts/
├─ models/
│  ├─ variants.json
│  ├─ ipad-m4-q4/
│  ├─ iphone-15pm-q4/
│  └─ lifeboat-q4/
├─ adapters/
│  ├─ bindings.json
│  └─ capability-lock.json
├─ ibd/
│  ├─ registry/
│  ├─ famlog/
│  ├─ clusters/
│  ├─ composites/
│  ├─ evidence/
│  ├─ last-orders/
│  └─ portable-store.sqlite
├─ self/
│  ├─ wet-bus/
│  ├─ inner-records/
│  └─ projections/
├─ ghosts/
│  ├─ index.json
│  └─ <ghost-id>/
├─ attachments/
├─ audit/
│  ├─ provenance.json
│  ├─ hashes.json
│  ├─ engine-switches.jsonl
│  └─ migrations.jsonl
└─ signatures/
```

folder名はdraftであり、正式なJSON Schema、UTType、MIME type、署名方式は実装fixtureによる検証後に
確定する。

## 3. root manifest

`manifest.json`はarchive内の参照起点であり、次の論理fieldを持つ。

```json
{
  "format_version": "0.1-draft",
  "archive_id": "astro:uuid",
  "generation": 1,
  "startability": "portable",
  "boot_profiles_ref": "boot/profiles.json",
  "model_variants_ref": "models/variants.json",
  "persona_ref": "persona/mitama.json",
  "ibd_ref": "ibd/",
  "ghost_index_ref": "ghosts/index.json",
  "integrity_ref": "audit/hashes.json"
}
```

JSON例はfield候補を示すdraftであり、Schema実装済みの主張ではない。

## 4. boot profileとModel Variant

boot profileは人格ではなく、特定端末でどの計算器を使用するかを記述する。

```json
{
  "boot_profiles": [
    {
      "id": "ipad-m4-primary",
      "model_ref": "model:moe-large-q4",
      "adapter_ref": "adapter:embedded-metal",
      "priority": 100,
      "requirements": {
        "platform": "ios",
        "device_class": ["ipad-pro-13-m4"],
        "minimum_memory_gib": 12
      }
    },
    {
      "id": "iphone-15pm",
      "model_ref": "model:compact-q4",
      "adapter_ref": "adapter:embedded-metal",
      "priority": 80,
      "requirements": {
        "platform": "ios",
        "device_class": ["iphone-15-pro-max"]
      }
    },
    {
      "id": "lifeboat",
      "model_ref": "model:lifeboat-q4",
      "adapter_ref": "adapter:embedded-metal",
      "priority": 10,
      "requirements": {
        "platform": "ios"
      }
    }
  ]
}
```

Model Variantは最低限、次を識別する。

- model family、revision、source lineage
- weight hash
- quantization
- tokenizerとconversation template
- artifact format
- 対象platform、architecture、accelerator
- 推定memory、disk、context長
- 必要Adapter capability
- licenseと再配布条件
- canary inputと期待する構造条件

## 5. 解決順序

Runnerは次の順序でboot候補を解決する。

1. `.astro`内にある端末最適Variant
2. 同一hashを持つ検証済みcontent-addressed cache
3. `.astro`内にある軽量Fallback
4. Userが明示許可した場合だけ、外部Storageまたは取得先
5. 互換候補がなければ`REPAIR_REQUIRED`

cache hitとarchive内artifactは同一hashで照合する。cacheに同名fileがあるだけでは再利用しない。

```text
AstroRunnerCache/
└─ sha256/
   └─ <artifact-hash>/
      ├─ model-artifact
      ├─ tokenizer
      ├─ compiled-profile
      └─ verification.json
```

portable profileはcacheを削除しても、対応対象として宣言した端末で最低一つのboot profileを解決できる
ことを目標とする。大きなmodelを外部mountし、archive内の救命艇modelで最低限の顕現を保証する構成を
許容する。

## 6. Engine binaryとmodel artifact

iOS／iPadOSでは、archive内の任意の未署名実行codeやdynamic libraryをpluginとして実行しない。

- 署名済み推論EngineとAdapter実装はAstro Runner側へ置く
- weight、tokenizer、量子化artifact、model設定は`.astro`またはcacheへ置ける
- 端末別compiled artifactは、Runnerが許可したdata形式とcapability contractに限定する
- Ollama、Sphere-aae、将来のremote firepowerはAdapterとしてmountする

model artifactとRunner executableを、どちらも曖昧に「バイナリー」と呼んで同じ配布規則へ入れない。

## 7. 起動状態

```text
ARCHIVE_DISCOVERED
  ↓ path／容量／hash検査
ARCHIVE_VERIFIED
  ↓ boot profile解決
PROFILE_RESOLVED
  ↓ persona／Storage mount
INSTANCE_MOUNTED
  ↓ Engine warmup／canary
READY
```

どこかで失敗した場合、後続状態へ進めない。

代表的な失敗code:

```text
ASTRO_ARCHIVE_CORRUPT
ASTRO_BOOT_PROFILE_MISSING
ASTRO_ADAPTER_UNAVAILABLE
ASTRO_MODEL_ARTIFACT_MISSING
ASTRO_MODEL_INCOMPATIBLE
ASTRO_STORAGE_CHECKPOINT_INVALID
ASTRO_HASH_MISMATCH
ASTRO_MIGRATION_REQUIRED
ASTRO_RESOURCE_INSUFFICIENT
```

## 8. 開いた状態での交換

model／Adapter交換はpersonaを直接変更せず、working session上のmount変更として扱う。

receiptには次を残す。

- source／target modelとhash
- source／target Adapterとcontract version
- tokenizer、template、context、capabilityの差
- 交換者、規則、時刻、理由
- 交換時のGhostとfork point
- loss、未対応能力、Fallback

交換結果を保存する場合は、新しいgenerationまたは明示的な`Save As`としてcheckpointする。

## 9. 開閉と停電復旧

Runnerは推論tokenごとにZIPを再生成しない。

1. archiveを展開前検査する
2. private working directoryへ安全に展開する
3. file lockとjournalを開始する
4. Storageをcheckpoint可能な状態で開く
5. 操作中はworking copyへ追記する
6. 保存時は一時archiveへ再梱包する
7. hashとmanifestを検査する
8. `fsync`相当の永続化後、atomic renameで世代を確定する

中断時は最後の正常archiveを上書きせず、working journalを復旧候補として保持する。復旧候補を
自動的に正本へmergeしない。

## 10. archive安全条件

- absolute path、`..`、path traversalを拒否する
- symlink、hard link、device fileを既定拒否する
- entry数、展開後容量、圧縮率へ上限を設ける
- ZIP bombを展開前に検査する
- unknown executable contentを起動しない
- manifest外artifactを暗黙mountしない
- secret、API token、外部credential本文を保存しない
- SQLite等を格納する場合、WALをcheckpointしてから梱包する
- 各artifactをhashとprovenanceで追跡する

## 11. 互換性と移行

- `format_version`が同じでもSemanticKernel差を自動的に同一人格へmergeしない
- migrationはsource archiveを変更せず、新generationへ出力する
- 変換できないfieldは削除せず`unknown`または隔離projectionとして保持する
- migration receiptへsource／target generation、変換規則、loss、実行者を残す

