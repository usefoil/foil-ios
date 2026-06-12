# T002 Candidate Build Receipt

Result: archive_export_done_upload_blocked

Build `0.1.0 (13)` was prepared and packaged locally.

Local candidate artifact:

- Archive: `/tmp/FoilIOS-BetaCandidate13.xcarchive`
- Export: `/tmp/FoilIOS-BetaCandidate13Export`
- IPA: `/tmp/FoilIOS-BetaCandidate13Export/Foil iOS.ipa`

Verification:

- `scripts/ios-simulator-sanity.sh`: passed.
- `xcodebuild archive ... -archivePath /tmp/FoilIOS-BetaCandidate13.xcarchive`: succeeded.
- `xcodebuild -exportArchive ... -exportPath /tmp/FoilIOS-BetaCandidate13Export`: succeeded.
- IPA metadata:
  - app version `0.1.0`, build `13`;
  - keyboard extension version `0.1.0`, build `13`;
  - `CFBundleIconName` is `AppIcon`.
- IPA package includes:
  - `AppIcon60x60@2x.png`;
  - `AppIcon76x76@2x~ipad.png`;
  - `Assets.car`.
- Archive signing inspection:
  - app bundle id `com.neonwatty.FoilIOS`;
  - keyboard bundle id `com.neonwatty.FoilIOS.Keyboard`;
  - team identifier `B3A6AN2HA4`.

Upload blocker:

`xcrun altool --validate-app` without credentials exited nonzero with
`AuthenticationFailure`: validation/upload requires either JWT API
key/issuer inputs or Apple ID app-password/provider inputs. No upload was
attempted.
