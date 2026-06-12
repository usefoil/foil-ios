# T002 Worker Receipt - Simulator Sanity Regression

Date: 2026-06-09

## Claim

`scripts/ios-simulator-sanity.sh` is now the fast simulator regression lane for
closed-beta polish.

## Changes

- Added `scripts/ios-simulator-sanity.sh`.
- Added `docs/ios-simulator-sanity-runbook.md`.
- The script prints a simulator-only claim boundary, runs `xcodebuild -list`,
  runs the full `FoilIOS` simulator test suite, and runs unsigned generic iOS
  compile.

## Evidence

`scripts/ios-simulator-sanity.sh` passed.

The run included:

- `xcodebuild -list -project FoiliOS/FoilIOS.xcodeproj`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17'`
- `xcodebuild build -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO`

## Residual risk

This lane is intentionally non-physical. It does not prove iPhone install,
Settings, Full Access, microphone permission on the preview phone, custom
keyboard availability inside host apps, or physical host-app insertion.
