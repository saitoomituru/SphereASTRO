# 人格StorageとInstance Ghost境界

> Status: Architecture Specification / 永続化実装はStage 3以降

## 1. 目的

人格、記憶、観測、会話、model出力を一つの可変chat databaseへ押し込み、何が正本で何が派生かを
追跡できなくなる事故を防ぐ。同じ`.astro`内へ格納しても、論理Database、更新権限、Provenanceを
分離する。

## 2. 保存する棚

| 棚 | 保存対象 | 更新規則 |
|---|---|---|
| `persona` | 御霊、荒御魂profile、価値基準、FAM profile | version付き。model交換で変更しない |
| `wet-bus` | 上位人格系がWet Busとして分類した入力、状態、観測 | append-first。分類者とRegistryを保持 |
| `inner-records` | ASTROが明示生成した自我内記録、内省、自己状態 | private scope。会話logと権限分離 |
| `ibd` | FAMLog、情報子cluster、Evidence、Last Order、Composite FAM | source非破壊。派生を別IDで保存 |
| `ghosts` | session、thread、fork、model／Body mount履歴 | event graph。source Ghostを上書きしない |
| `audit` | hash、engine switch、migration、失敗、復旧receipt | append-onlyを基本とする |
| `attachments` | 画像、音声、Body asset等 | license、hash、参照元を必須化 |

Wet Busと自我内記録の存在論をSphereASTRO Coreが独自に真偽判定しない。上位Registry、fact scope、
記録者、観測時点を保持する。

## 3. 保存しないもの

- model内部の未観測hidden stateを、後から「当時の自我」と推定した記録
- 外部API token、password、秘密鍵、credential本文
- sourceを変更したように見せる遡及OAE
- cacheにしか存在しない人格正本
- model出力だけから確定したObserver、Intent、Causal Agency

自我内記録は、ASTRO側が明示的に生成、分類、保存した記録である。model内部にあったかもしれない状態を
遡及生成しない。

## 4. IBD portable profile

`.astro`は起動に必要な人格Storageを内包するportable IBD profileを持てる。

```text
Portable IBD
  ├─ Registry snapshot
  ├─ FAMLog
  ├─ source Infoton Clusters
  ├─ Composite FAM recipes
  ├─ Evidence
  ├─ Last Orders
  └─ external Storage Bindings
```

外部graph、vector、object store、業務systemは追加bindingである。bootに必要な最小snapshotはarchiveへ
含める。外部bindingが切れた場合、取得できない記録を生成せず`IBD_EXTERNAL_BINDING_UNAVAILABLE`を返す。

Composite FAMはsource clusterを変更しない。永続化する場合もsource refs、Mapping FAM、順序、
Q、Evidence、lossを保持した派生物として保存する。

## 5. Stageごとの永続化

| Stage | 永続化状態 |
|---|---|
| Stage 0 | build receiptだけ。人格Storageなし |
| Stage 1 | 読み取り専用fixture。Chat差分は`EPHEMERAL` |
| Stage 2 | Body／IBD接続spike。一時Storeであり人格正本ではない |
| Stage 3以降 | AAE Bake後の人格Storage、Wet Bus、自我内記録、Ghost checkpoint |

Stage 1／2で得た実験logを、後から人格の過去記憶へ自動注入しない。採用する場合は現在の選択として
新しいreceiptを作る。

## 6. Local Instance Ghost

SphereASTROの初期実装は`Astro Local Instance Ghost`とする。

```text
scope: APPLICATION_PROFILE
atlantis_7d_runtime: NOT_IMPLEMENTED
```

各Ghostは最低限、次を持つ。

- stable Ghost ID
- parent Ghost ID
- fork point
- persona generation
- model、Adapter、Body、Storage snapshot refs
- conversation／event sequence
- creation、freeze、resume、merge receipts

これは将来のAtlantis接続を妨げないapplication profileであるが、完全な7D Fold runtimeや
Akasha Driver実装済みの主張には使用しない。

## 7. thread表示と非破壊merge

threadは可変の一本線ではなく、Ghost event graphとして表示する。

```text
Ghost A ─────┐
             ├─ Merge Ghost C
Ghost B ─────┘
```

mergeはAとBを変更せず、Cを新規生成する。merge receiptは次を持つ。

- source Ghost refs
- target Ghost ref
- fork／merge point
- 選択したevent、memory、projection
- 除外した項目と理由
- conflict、unknown、loss
- Mapping FAMまたはUser decision
- `source_mutation: false`

自動的な近似vector一致だけで別Ghostの自我内記録を混ぜない。

## 8. privacyとexport

- Wet Bus、自我内記録、会話、公開可能profileは個別export範囲を持つ
- archive全体の共有を、全記録の公開同意とみなさない
- `Save As`、redacted export、凍結、破棄を別操作にする
- secret本文はexport対象にしない
- attachmentごとのlicense、同意、出典を保持する
- 暗号化方式と鍵管理は`UNKNOWN`として実装前User Gateへ返す

