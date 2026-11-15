#!/usr/bin/env bash
# Runs the BoringCore unit tests natively (no iOS device or simulator needed).
# `swift test` alone would also try to build the iOS app target, which needs the iOS SDK,
# so we build just the test product and then run it.
set -euo pipefail
cd "$(dirname "$0")/.."
swift build --product BoringPhonePackageTests
swift test --skip-build "$@"
