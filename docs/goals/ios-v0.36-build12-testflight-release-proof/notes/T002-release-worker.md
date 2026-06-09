# T002 Release Worker

## Claim

Foil iOS build `0.1.0 (12)` was prepared from source, tested, archived,
exported, validated, uploaded to App Store Connect, marked export-compliance
safe, and attached to `Foil Internal Testers`.

## Source And Build Metadata

- `FoiliOS/project.yml` changed `CURRENT_PROJECT_VERSION` from `11` to `12`.
- `xcodegen generate --spec project.yml` regenerated
  `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`.
- Generated build settings show `CURRENT_PROJECT_VERSION=12` and
  `MARKETING_VERSION=0.1.0`.

## Verification

- Xcode Build MCP simulator tests passed: `23 passed / 0 failed / 0 skipped`.
- Release archive succeeded at `/tmp/FoilIOS-v036-build12.xcarchive`.
- Export succeeded to `/tmp/FoilIOS-v036-build12-export/Foil iOS.ipa`.
- IPA metadata inspection showed:
  - app bundle `com.neonwatty.FoilIOS`, version `0.1.0`, build `12`
  - keyboard bundle `com.neonwatty.FoilIOS.Keyboard`, version `0.1.0`, build `12`
  - `CFBundleIconName` is `AppIcon`
  - `AppIcon60x60@2x.png`, `AppIcon76x76@2x~ipad.png`, and `Assets.car` are present
- IPA SHA-256:
  `2058385fe65bc51e2dd0bca603b099eb7de0c6834e19dca794745eae5f15d7a6`

## App Store Connect

- `altool --validate-app` reported `VERIFY SUCCEEDED with no errors`.
- `altool --upload-app` reported `UPLOAD SUCCEEDED with no errors`.
- Delivery UUID / build ID: `75f05a85-cfe5-443f-bc9a-32ff8c27b710`
- `altool --build-status` reported:
  - `build-status: VALID`
  - `import-status: VALID`
  - `is-on-app-store-connect: true`
  - `uses-non-exempt-encryption: false`
- App Store Connect REST found build version `12` with processing state `VALID`.
- App Store Connect REST PATCH set `usesNonExemptEncryption=false`.
- Beta detail after attachment:
  - `internalBuildState: IN_BETA_TESTING`
  - `externalBuildState: READY_FOR_BETA_SUBMISSION`
- `Foil Internal Testers` contains build `12`.

## Commands

- `xcodegen generate --spec project.yml`
- Xcode Build MCP `test_sim`, scheme `FoilIOS`, simulator `iPhone 17`
- `xcodebuild archive -project FoilIOS.xcodeproj -scheme FoilIOS ...`
- `xcodebuild -exportArchive ...`
- IPA metadata inspection with `PlistBuddy`
- `xcrun altool --validate-app ...`
- `xcrun altool --upload-app ...`
- `xcrun altool --build-status ...`
- App Store Connect REST PATCH/query/attach calls with bearer token kept out of receipts

## Residual Risk

This proves App Store Connect/TestFlight availability for build 12. It does not
prove that iPhone-preview has installed build 12 or that the physical onboarding
and host-app rows pass on build 12; those are owned by v0.37 and v0.38.
