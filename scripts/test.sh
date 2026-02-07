#!/usr/bin/env bash
set -euo pipefail

PROJECT="${PROJECT:-SphereASTRO.xcodeproj}"
SCHEME="${SCHEME:-SphereASTRO}"
CONFIGURATION="${CONFIGURATION:-Debug}"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPhone 15}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-.build/DerivedData}"
XCCONFIG="${XCCONFIG:-config/ci-signing-off.xcconfig}"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "[test] xcodebuild が見つかりません。Xcode Command Line Tools をインストールしてください。" >&2
  exit 127
fi

mkdir -p "${DERIVED_DATA_PATH}"

xcodebuild \
  -project "${PROJECT}" \
  -scheme "${SCHEME}" \
  -configuration "${CONFIGURATION}" \
  -destination "${DESTINATION}" \
  -derivedDataPath "${DERIVED_DATA_PATH}" \
  -xcconfig "${XCCONFIG}" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  test
