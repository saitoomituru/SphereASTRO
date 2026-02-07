# SphereASTRO

SphereASTRO は、人間主権（Human Sovereignty）を維持するために、
対話体験の入口となる GUI と責任境界を設計するプロジェクトである。
本プロジェクトは、AIを主体化せず、判断根拠と運用責任を人間側に残すことを目的とする。

## Vision / Philosophy
- 人間主権を前提とし、判断と責任の最終主体は常に人間とする。
- 責任分界を明示し、判断過程の追跡可能性を確保する。
- AIを主体にしない。AIは演算資源であり、責任主体ではない。
- 人格（御霊）を明示的に定義することで、価値前提と判断規範を不可視化しない。

## What SphereASTRO Is / Is Not
- これは一般的なAIチャットアプリではない。
- これはLLMそのものではない。
- これは、人間の判断主体を保つためのGUIと境界層（Boundary Layer）である。

## Core Concepts (High Level)
- **御霊（Mitama）**: 判断規範を明示する人格モデル。
- **依代（Yorishiro）**: 推論を実行する計算基盤。
- **FAM（ψ / ▽φ / λ / Q）**: 判断の文脈と経路を記述する高位フレーム。

## Runtime / Execution Model
- ローカル実行を基本とし、利用者が実行環境を把握できる構造を優先する。
- エッジAI（Edge AI）およびオフライン運用を可能とする設計を採る。
- SaaS前提に固定しない。理由は、責任境界・監査性・運用自律性を維持するためである。

## Current Status
- 実装言語・UI基盤: Swift / SwiftUI
- 対応対象: macOS / iOS
- 対話形態: ソロチャット（1人Mattermost相当）
- AI接続: 未接続（後段で統合予定）

## Responsibility & Law
- AIは無罪である。責任主体は人間である。
- 設計者・運用者・配布者の責任を分離し、説明可能な形で保持する。
- 押収・監査・再現に対応できる構造を前提に設計する。

## Documentation
技術仕様・アルゴリズム・内部構造は
docs/ 以下に分離されています。

- 全体索引: [`docs/README.md`](docs/README.md)
- 概念定義（Concepts）: [`docs/concepts/`](docs/concepts/)
- アーキテクチャ（Architecture）: [`docs/architecture/`](docs/architecture/)
- アルゴリズム（Algorithms）: [`docs/algorithms/`](docs/algorithms/)
- Sleep Bake 詳細: [`docs/algorithms/sleep-bake-algorithm.md`](docs/algorithms/sleep-bake-algorithm.md)
- FAM 概念と層設計: [`docs/concepts/fam.proton.md`](docs/concepts/fam.proton.md), [`docs/architecture/fam-layers.md`](docs/architecture/fam-layers.md)
- EdoHAGE 監査チェーン: [`docs/concepts/audit-chain-edohage.proton.md`](docs/concepts/audit-chain-edohage.proton.md)
- GUI責務分離: [`docs/architecture/gui-responsibility.md`](docs/architecture/gui-responsibility.md)

## License
Apache 2.0
