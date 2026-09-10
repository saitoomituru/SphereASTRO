# SphereASTRO component submodules 2026-09

状態: `[SOURCE-PINNED]` `[RUNTIME-INTEGRATION-PENDING]`
更新日: 2026-09-10

## 目的

SphereASTRO が Actor / Persona / Identity / Continuity を組み立てる際に、IBD、Sphere-aae、FQueryをcopyや独自forkではなく、それぞれの正本repositoryをrevision固定してlibrary sourceとして利用できるようにする。

## 現在のsubmodule

```text
vendor/FQuery
  source: https://github.com/saitoomituru/FQuery.git
  pinned: 5def6e85a1f448aa9c92cfb761bc655aa07c3bdc

vendor/IBD
  source: https://github.com/saitoomituru/IBD.git
  pinned: 93834835d2da791bfa7c85e18df57cc5354a202b

vendor/Sphere-aae
  source: https://github.com/saitoomituru/Sphere-aae.git
  pinned: f67fa20df0ad23980e9b7f2cfa4deea6e6ecff60
```

## 責務

```text
FQuery
  FAM selector / traversal / query

IBD
  memory / evidence / storage / retrieval

Sphere-aae
  model / inference / system-call execution

SphereASTRO
  Actor / persona / identity / continuity
  component binding / manifestation
```

submoduleはsource pinであり、runtime必須依存やownership移転ではない。

```text
retrieved memory != adopted memory
AAE model artifact != ASTRO identity
FQuery grammar != ASTRO ontology
```

## clone / update

新規clone:

```bash
git clone --recurse-submodules https://github.com/saitoomituru/SphereASTRO.git
```

既存clone:

```bash
git submodule update --init --recursive
```

上流更新は明示的に対象revisionを選び、親repository側のgitlink更新としてreviewする。runtimeが勝手に各submoduleの`main`へ追随しない。

## optionality

submoduleがsource treeに存在することと、すべてのbuild/profileでそのcomponentがrequiredであることを同一視しない。

- FQueryを使わない最小GUI fixtureを許容できる
- IBD未接続ならmemory/storage stateを`unavailable`または`not-mounted`として扱える
- AAE以外のEngine Adapterを利用できる余地を残す
- Atlantis接続なしでもASTRO standalone Agencyを成立させられる

required / optionalは将来のbuild profile / boot profileで明示する。

## 検証状態

- `.gitmodules`: added
- `vendor/FQuery`: gitlink mode `160000`
- `vendor/IBD`: gitlink mode `160000`
- `vendor/Sphere-aae`: gitlink mode `160000`
- source revisions: pinned
- clean clone + recursive checkout: `NOT TESTED` in this change
- Swift/API integration: `NOT IMPLEMENTED` by this change alone
