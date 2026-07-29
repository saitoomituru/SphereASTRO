SHELL := /bin/bash

PROJECT := SphereASTRO.xcodeproj
SCHEME := SphereASTRO
CONFIGURATION ?= Debug
DESTINATION ?= generic/platform=iOS Simulator
IPAD_SIMULATOR_DESTINATION ?= platform=iOS Simulator,name=iPad Pro 13-inch (M4)
DERIVED_DATA_PATH ?= .build/DerivedData
XCCONFIG ?= config/ci-signing-off.xcconfig

.PHONY: build test test-iphone-device test-ipad-device ci clean help

help:
	@echo "利用可能ターゲット:"
	@echo "  make build  - SwiftUI GUI 層を Code Signing 無効でビルド"
	@echo "  make test   - 既存iPad Pro 13-inch (M4) Simulatorでテスト"
	@echo "  make test-iphone-device IPHONE_DEVICE_ID=<UDID>"
	@echo "             - iPhone 15 Pro Max実機でテスト"
	@echo "  make test-ipad-device IPAD_DEVICE_ID=<UDID>"
	@echo "             - iPad Pro 13-inch (M4)実機でテスト"
	@echo "  make ci     - CI向け一括実行 (build + test)"
	@echo "  make clean  - 生成物を削除"

build:
	@./scripts/build.sh

test:
	@DESTINATION="$(IPAD_SIMULATOR_DESTINATION)" ./scripts/test.sh

test-iphone-device:
	@test -n "$(IPHONE_DEVICE_ID)" || { echo "IPHONE_DEVICE_IDにiPhone 15 Pro MaxのUDIDを指定してください。" >&2; exit 2; }
	@DESTINATION="platform=iOS,id=$(IPHONE_DEVICE_ID)" HARDWARE_CLASS="iphone-15-pro-max" ./scripts/test.sh

test-ipad-device:
	@test -n "$(IPAD_DEVICE_ID)" || { echo "IPAD_DEVICE_IDにiPad Pro 13-inch (M4)のUDIDを指定してください。" >&2; exit 2; }
	@DESTINATION="platform=iOS,id=$(IPAD_DEVICE_ID)" HARDWARE_CLASS="ipad-pro-13-m4" ./scripts/test.sh

ci:
	@./scripts/ci.sh

clean:
	rm -rf .build
