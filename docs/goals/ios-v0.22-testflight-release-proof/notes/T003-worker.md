# T003 Worker Receipt: Build 11 Local Release Prep

## Claim

Foil iOS build `0.1.0 (11)` was prepared from source, archived, exported, and
proved as an App Store Connect-ready IPA with matching containing-app and
keyboard-extension metadata.

## Strongest Realistic Failure Mode

The exported artifact could have been stale or mismatched, with the containing
app and keyboard extension not both carrying build `11`.

## Evidence

- `FoiliOS/project.yml` changed `CURRENT_PROJECT_VERSION` from `10` to `11`.
- `xcodegen generate --spec project.yml` regenerated
  `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`.
- Generated project inspection found only `CURRENT_PROJECT_VERSION = 11` and
  `MARKETING_VERSION = 0.1.0`.
- Focused simulator tests passed: `21 tests, 0 failures`.
- Release archive succeeded at `/tmp/FoilIOS-v022-build11.xcarchive`.
- App Store Connect export succeeded to
  `/tmp/FoilIOS-v022-build11-export/Foil iOS.ipa`.
- IPA metadata inspection showed:
  - app bundle `com.neonwatty.FoilIOS`, version `0.1.0`, build `11`
  - keyboard bundle `com.neonwatty.FoilIOS.Keyboard`, version `0.1.0`, build
    `11`
- IPA SHA-256:
  `dac9c7f904302ac3d33b8fd1788b17f11aff5ad92a5365d18018c0c081f20a55`

## Commands

- `cd FoiliOS && xcodegen generate --spec project.yml`
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS ...`
- `xcodebuild archive -project FoilIOS.xcodeproj -scheme FoilIOS ...`
- `xcodebuild -exportArchive -archivePath /tmp/FoilIOS-v022-build11.xcarchive ...`
- `PlistBuddy` inspection of app and keyboard `Info.plist` inside the exported
  IPA

## Residual Risk / Follow-Up

Local artifact proof does not prove TestFlight install or live keyboard
insertion. T004 owns upload, TestFlight attachment, iPhone install/update, and
physical smoke.
