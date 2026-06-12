#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$ROOT_DIR/FoiliOS/FoilIOS.xcodeproj"
SCHEME="FoilIOS"
SIM_DESTINATION="${IOS_SIMULATOR_DESTINATION:-platform=iOS Simulator,name=iPhone 17}"

echo "foil-ios-simulator-sanity: simulator-only regression lane"
echo "foil-ios-simulator-sanity: this does not prove physical keyboard insertion or host-app behavior"
echo "foil-ios-simulator-sanity: destination=$SIM_DESTINATION"

xcodebuild -list -project "$PROJECT"

xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "$SIM_DESTINATION"

xcodebuild build \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO

echo "foil-ios-simulator-sanity: passed"
