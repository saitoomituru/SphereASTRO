#!/usr/bin/env bash
set -euo pipefail

"$(dirname "$0")/build.sh"
DESTINATION="${DESTINATION:-platform=iOS Simulator,name=iPad Pro 13-inch (M4)}" \
HARDWARE_CLASS="${HARDWARE_CLASS:-ipad-pro-13-m4-simulator}" \
  "$(dirname "$0")/test.sh"
