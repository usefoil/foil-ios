# T001 TestFlight Preflight Receipt

Result: upload_blocker_identified

Preflight found a safe local build path and an exact upload blocker.

Local state:

- Xcode: `26.5`
- `altool`: `26.40.1`
- Project metadata before candidate prep: `0.1.0 (12)`
- Source was bumped to candidate build `0.1.0 (13)` in `FoiliOS/project.yml`
  and regenerated into `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`.
- One App Store Connect private-key file is present in the standard local key
  directory; the key contents were not read or printed.
- No obvious App Store Connect / altool environment variables were present.
- `iPhone-preview` was not safe for physical host-app testing during preflight:
  strict physical preflight exited nonzero with WDA unreachable.

Commands:

- `rg -n 'MARKETING_VERSION|CURRENT_PROJECT_VERSION|DEVELOPMENT_TEAM|PRODUCT_BUNDLE_IDENTIFIER|CODE_SIGN|App Groups|group.com' FoiliOS/project.yml FoiliOS/FoilIOS.xcodeproj/project.pbxproj`
- `find "$HOME/.appstoreconnect/private_keys" -maxdepth 1 -name 'AuthKey_*.p8' | wc -l`
- `env | cut -d= -f1 | rg '^(ASC|APP_STORE|APPSTORE|API_PRIVATE_KEYS_DIR|APP_STORE_CONNECT|ITMS|ALTOOL|FASTLANE|APPLE)' || true`
- `scripts/ios-physical-harness.py preflight --strict`

Decision:

Proceed with local candidate archive/export and metadata proof. Do not attempt
App Store Connect validation/upload until the operator provides the API
key/issuer pair or Apple ID app-password/provider path through a safe channel.
