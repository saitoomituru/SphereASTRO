# SphereASTRO 責務境界 2026-09

状態: `[CANONICAL-CORRECTIVE]` `[TARGET-SPEC]`
更新日: 2026-09-10

## 一文定義

> SphereASTRO は、Model / runtime / storage / Body を一つの **Actor / persona / identity / continuity** としてmountし、利用者へ顕現状態と責任境界を提示する人格・Agency境界である。

ASTROはWorld全体のorchestration、FQuery文法、IBD storage意味論、AAE model鍛造責務を所有しない。

## 横断責務

```text
ZeroRoomLab-manifest
  common contract / ontology vocabulary

FQuery
  FAM graph / selector / traversal / fam_ref

IBD
  memory / evidence / FAM / provenance storage

Sphere-aae
  model / inference / system-call execution runtime

SphereASTRO
  Mitama / persona / identity / continuity
  Model + Memory + Body + Tool binding
  Agency Endpoint

SphereOS Atlantis
  World / Fold orchestration
  Portal / Gate / authority / task routing
```

## ASTROが所有する

- `.astro` archive / package boundary
- Mitama / Persona / Instance identityのbinding
- identity continuityを壊さないmount / unmount / fallback
- Model Variant / Engine Adapterの選択と状態表示
- IBD memory/storage binding
- Body / Tool presentation boundary
- manifestation state
- Agency Endpoint
- model/runtime/storage差分をidentity差分と混同しないreceipt
- standalone起動
- Human Sovereignty application governance profile

## ASTROが所有しない

- FQuery grammar / selector / traversalの制定
- refFAMの真偽・宗派優劣裁定
- IBD Coreの保存・検索意味論
- AAE Bake / Model Family鍛造の正本
- Atlantis World / Fold / Portal / causal gateの正本
- provider-managed Assistantのidentityを強制的にASTRO ownershipへ移すこと
- OAEのWorld-global因果裁定

## FQueryとの境界

ASTROはFQueryを、人格・Body・Tool・Memory等を結ぶFAM graphのquery / traversal libraryとして利用できる。

FQuery正本:

```text
self = current FAM module
this = current node

L-axis
  parent / children / siblings / prev / next

mL-axis
  before / after
```

ASTROの`Mitama`、`Astral`、`Elemental`等はFQuery Core hard-codeではなく、ASTRO domain Registry / refFAM / Access Mapから注入される。

## IBDとの境界

IBDは人格の記憶・Evidence・FAM・OAE receiptを保存できるが、検索されたrecordをASTROの「自分の記憶」として自動採用しない。

```text
ASTRO
  identity / active instance
     ↓ memory query
FQuery
     ↓
IBD
  candidate memory / evidence / Last Order
     ↓
ASTRO / active Actor
  adoption / reject / unknown
```

IBD storage identityとASTRO persona identityを同一化しない。

## AAEとの境界

AAEはASTROがmount可能なmodel/runtime供給元の一つである。

```text
ASTRO identity
    ↓ vessel binding
AAE model/runtime
    ↓ execution receipt
ASTRO continuity evaluation
```

AAE model swapはASTRO identity swapではない。逆に同名Personaを別modelへ載せただけでcontinuity成立とも決めない。

ASTROはAAEを唯一のModel供給元にしない。generic local runtime / direct Model API等もAdapterとして許容できる。

## Atlantisとの境界

ASTROはstandaloneで起動できる。AtlantisはASTRO Agencyを複数World / Fold / taskへ配置する上位orchestratorであり、ASTROの成立条件ではない。

```text
ASTRO
  Actor / Agency Endpoint
       ↓ admission
Atlantis
  World / Fold / authority / task
  direct / Portal / Gate / Bottom
```

異なるrefFAM / World間のPortal必要性をASTRO自身が決定しない。

## refFAMと人格

refFAMはfact-freeな形而上学・認識論・方法であり、人格のWorld viewや解釈規則としてmountできる。

ただし:

```text
persona uses refFAM
!= refFAM becomes empirical fact

refFAM conflict
!= permission to rewrite observed fact
```

同一Actorが複数refFAMを持つ場合、そのscope / priority / Access Map / conflict handlingは明示する。別refFAMとの衝突をASTROが普遍真理で裁定せず、必要ならAtlantis / upper Registryへ返す。

## Git submodule方針

SphereASTROは次をlibrary sourceとしてpinできる。

```text
vendor/IBD
vendor/Sphere-aae
vendor/FQuery
```

Git submoduleはsource revisionを固定する配布・開発手段であり、ownershipやruntime必須依存を意味しない。

- IBDの意味正本はIBD repository
- AAEの意味正本はSphere-aae repository
- FQueryの意味正本はFQuery repository
- ASTROはconsumer / integrator
- submodule未初期化時に「機能実装済み」と表示しない
- optional / required dependencyはbuild profileで別に定義する

## 受入条件

- [ ] FQuery / IBD / AAEを別library responsibilityとしてmount可能
- [ ] model swapとidentity swapを分離
- [ ] memory retrievalとmemory adoptionを分離
- [ ] ASTRO domain labelsをFQuery Coreへhard-codeしない
- [ ] standalone起動を維持
- [ ] Atlantis接続時もWorld authorityをASTROが自己生成しない
- [ ] refFAM conflictでobserved factを書き換えない
- [ ] submodule pin revisionをreceipt / build infoへ露出可能

## 正本参照

- `docs/specification/astro-runner-requirements.ja.md`
- ZeroRoomLab-manifest `docs/theory/sphere-context-dimension-os.ja.md`
- ZeroRoomLab-manifest `docs/theory/sphere-context-sdk-contract.ja.md`
- FQuery `docs/specification/fquery-selector-traversal-normalization.ja.md`
- IBD `docs/architecture/responsibility-boundary-2026-09.ja.md`
- Sphere-aae `docs/architecture/responsibility-boundary-2026-09.ja.md`
- SphereOS-Atlantis World / Portal contracts
