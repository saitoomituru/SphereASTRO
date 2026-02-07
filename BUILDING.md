# BUILDING.md

## 目的
このドキュメントは、SphereASTRO（SwiftUI GUI 層）のビルド / テスト手順を **単一入口（single entry point）** で明確化し、Codex と CI が迷わない状態を維持するためのものです。

## 前提
- 本リポジトリは GUI 層専用です。
- 思考・ロジック・AI エンジンは別プロセス / 別リポジトリで扱います。
- Code Signing（コード署名）なしでビルド / テストできるように設定しています。

## 単一入口
### ビルド
```bash
make build
```

### テスト
```bash
make test
```

### CI 相当（ビルド + テスト）
```bash
make ci
```

## 実体
- `make build` → `scripts/build.sh`
- `make test` → `scripts/test.sh`
- `make ci`   → `scripts/ci.sh`

各スクリプトは `config/ci-signing-off.xcconfig` を読み込み、署名依存を排除して実行します。

## 失敗時の確認
1. `xcodebuild` が存在するか（Xcode Command Line Tools）。
2. Scheme 名が `SphereASTRO` であるか。
3. Simulator destination を環境に合わせて上書きする。

例:
```bash
DESTINATION='platform=iOS Simulator,name=iPhone 15' make test
```
