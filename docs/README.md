# SphereASTRO Docs Index

本ディレクトリは、SphereASTRO の設計文書群である。
README から分離した仕様を、要求・概念・設計・アルゴリズム・UXの棚で管理する。

## 0. Specification（要求正本）
- [ASTRO Runner要求仕様](./specification/astro-runner-requirements.ja.md)
- [ASTROファイル形式](./specification/astro-file-format.ja.md)

## 1. Concepts（思想・概念定義）
- [FAM（Fold Access Mapper）](./concepts/fam.proton.md)
- [御霊（Mitama）](./concepts/mitama.proton.md)
- [依代（Yorishiro）](./concepts/yorishiro.proton.md)
- [自我と責任（Ego and Responsibility）](./concepts/ego-and-responsibility.proton.md)
- [Sleep Bake 概念](./concepts/sleep-bake.proton.md)
- [EdoHAGE 監査チェーン](./concepts/audit-chain-edohage.proton.md)

## 2. Architecture（責務分離・境界設計）
- **[2026-09 現行責務境界](./architecture/responsibility-boundary-2026-09.ja.md)**
- **[2026-09 component submodules](./architecture/component-submodules-2026-09.ja.md)**
- [FAM レイヤ設計](./architecture/fam-layers.md)
- [GUI 責務定義](./architecture/gui-responsibility.md)
- [Engine Boundary（依代境界）](./architecture/engine-boundary.md)
- [人格StorageとInstance Ghost境界](./architecture/personality-storage.md)
- [対応実機・検証炉](./architecture/supported-hardware.md)
- [Sphere共通Context Dimension OS](https://github.com/saitoomituru/ZeroRoomLab-manifest/blob/main/docs/theory/sphere-context-dimension-os.ja.md) — 技術Layer `L`とContext Dimension `D`、OAEの横断正本候補

2026-09以降のcomponent境界は次を基準にする。

```text
FQuery     = FAM selector / traversal / query
IBD        = memory / evidence / storage / retrieval
AAE        = model / system-call execution runtime
ASTRO      = Actor / persona / identity / continuity / vessel binding
Atlantis   = World / Fold orchestration / Portal / authority
```

ASTROはIBD・AAE・FQueryをlibraryとして利用できるが、それぞれの意味正本をASTROへ移さない。

## 3. Algorithms（実装可能仕様）
- [Sleep Bake アルゴリズム](./algorithms/sleep-bake-algorithm.md)
- [FAM Logging アルゴリズム](./algorithms/fam-logging.md)

## 4. UX（状態Presentation）
- [妖怪・式神顕現UX](./ux/manifestation-states.md)

## 利用順序
1. `specification` で製品契約とStage Gateを確認する。
2. `concepts` で用語と価値前提を固定する。
3. `architecture/responsibility-boundary-2026-09.ja.md` でcomponent責務を確認する。
4. `architecture/component-submodules-2026-09.ja.md` で外部正本のpinと初期化方法を確認する。
5. `architecture` で個別責務境界を確定する。
6. `algorithms` を実装仕様として利用する。

この順序により、思想 → 構造 → 実装 → 監査 の整合性を維持する。
