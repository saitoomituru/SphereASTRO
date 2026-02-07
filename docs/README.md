# SphereASTRO Docs Index

本ディレクトリは、SphereASTRO の設計文書群である。
README から分離した仕様を、概念・設計・アルゴリズムの3層で管理する。

## 1. Concepts（思想・概念定義）
- [FAM（Fold Access Mapper）](./concepts/fam.proton.md)
- [御霊（Mitama）](./concepts/mitama.proton.md)
- [依代（Yorishiro）](./concepts/yorishiro.proton.md)
- [自我と責任（Ego and Responsibility）](./concepts/ego-and-responsibility.proton.md)
- [Sleep Bake 概念](./concepts/sleep-bake.proton.md)
- [EdoHAGE 監査チェーン](./concepts/audit-chain-edohage.proton.md)

## 2. Architecture（責務分離・境界設計）
- [FAM レイヤ設計](./architecture/fam-layers.md)
- [GUI 責務定義](./architecture/gui-responsibility.md)
- [Engine Boundary（依代境界）](./architecture/engine-boundary.md)

## 3. Algorithms（実装可能仕様）
- [Sleep Bake アルゴリズム](./algorithms/sleep-bake-algorithm.md)
- [FAM Logging アルゴリズム](./algorithms/fam-logging.md)

## 利用順序
1. `concepts` で用語と価値前提を固定する。
2. `architecture` で責務境界を確定する。
3. `algorithms` を実装仕様として利用する。

この順序により、思想 → 構造 → 実装 → 監査 の整合性を維持する。
