SHELL := /bin/bash

PROJECT := SphereASTRO.xcodeproj
SCHEME := SphereASTRO
CONFIGURATION ?= Debug
DESTINATION ?= generic/platform=iOS Simulator
DERIVED_DATA_PATH ?= .build/DerivedData
XCCONFIG ?= config/ci-signing-off.xcconfig

.PHONY: build test ci clean help

help:
	@echo "利用可能ターゲット:"
	@echo "  make build  - SwiftUI GUI 層を Code Signing 無効でビルド"
	@echo "  make test   - テストを Code Signing 無効で実行"
	@echo "  make ci     - CI向け一括実行 (build + test)"
	@echo "  make clean  - 生成物を削除"

build:
	@./scripts/build.sh

test:
	@./scripts/test.sh

ci:
	@./scripts/ci.sh

clean:
	rm -rf .build
