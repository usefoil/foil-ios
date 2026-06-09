# T001 Release Preflight

## Decision

`approve_build12_release_worker`

## Current Source Metadata

`FoiliOS/project.yml` and Release build settings currently declare:

- `MARKETING_VERSION=0.1.0`
- `CURRENT_PROJECT_VERSION=11`
- app bundle ID: `com.neonwatty.FoilIOS`
- keyboard bundle ID: `com.neonwatty.FoilIOS.Keyboard`
- development team: `B3A6AN2HA4`
- signing style: automatic

The next build should be `0.1.0 (12)`.

## Tooling And Auth Readiness

Present:

- Xcode `26.5` build `17F42`
- XcodeGen `2.45.4`
- `altool` through Xcode
- one App Store Connect private key file in the expected private-key directory

Environment:

- No App Store Connect-like environment variables were printed or required.
- Credential check was presence-only; no private key, JWT, password, or token was printed.

Read-only App Store Connect proof:

- `altool --list-apps --filter-bundle-id com.neonwatty.FoilIOS` authenticated successfully.
- Matching app count: `1`
- App: `Foil Dictation`
- Apple ID: `6777069277`
- SKU: `foil-ios-001`

## Product Readiness

The v0.32 onboarding polish is present in source:

- `FoiliOS/Shared/FoilDictationLoopPresenter.swift` exposes `setupChecklistPresentation()` and `betaGuidancePresentation()`.
- `FoiliOS/FoilIOSApp/ContentView.swift` renders `Closed beta setup` and `Where to test`.
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift` covers the new presenter copy.

## Worker Path

Approved bounded worker:

1. Bump `FoiliOS/project.yml` from build `11` to build `12`.
2. Regenerate `FoilIOS.xcodeproj` with XcodeGen.
3. Run focused/full iOS simulator tests appropriate to the metadata change.
4. Archive/export a Release IPA.
5. Inspect app and keyboard IPA metadata for version `0.1.0`, build `12`.
6. Validate/upload the IPA with App Store Connect API authentication.
7. Check build processing status.
8. Clear export compliance if App Store Connect reports it is needed.
9. Attach build 12 to `Foil Internal Testers`.
10. Record sanitized receipts and run secret/raw-artifact scans.

## Stop Conditions

Stop before upload or record an exact blocker if:

- App Store Connect authentication starts requiring new private human input.
- Archive/export requires interactive account action.
- IPA metadata does not show app and keyboard build `12`.
- Any command would print private key contents, JWTs, passwords, bearer tokens, or private phone content.
