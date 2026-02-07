# CONTRIBUTING.md

## このリポジトリの責務（Responsibility Boundary）
- このリポジトリは **Swift / SwiftUI の GUI 層** を扱います。
- 思考・ロジック・AI エンジンの実装は対象外です。
- 既存 Swift コードの設計思想を尊重し、意味変更を伴う改変は行いません。

## Codex / CI 作業ルール
1. 入口は `make build` / `make test` / `make ci` のみを使用する。
2. Code Signing 前提の手順を追加しない。
3. GUI 層の安全性を保つため、ロジック実装や設計変更を持ち込まない。
4. 変更理由（why）と責任境界（where）を文章で残す。

## 変更可能な範囲
- ビルド補助ファイル（Makefile, scripts, xcconfig）
- CI 補助（ローカル再現可能なスクリプト、ワークフロー）
- ドキュメント（BUILDING.md, 本ファイル, ガード文書）

## 禁止事項
- Swift ロジック実装の追加
- 既存 Swift ファイルの意味変更
- FAM / 思考構造 / エンジン設計への介入
- 主観的リファクタ（「より良い設計」名目での改変）

## 推奨チェック
```bash
make build
make test
```

環境上 `xcodebuild` がない場合は、CI または macOS 開発環境で同手順を再実行してください。
