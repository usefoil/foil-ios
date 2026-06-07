# T001 Scout - Release Readiness

## Result

Done.

## Summary

The v0.18-v0.21 tranche is ready to package from source, but the full
TestFlight/upload portion is not currently executable because App Store Connect
authentication is incomplete in this fresh split repo context.

## Findings

- Current source metadata is `0.1.0 (10)` in both `FoiliOS/project.yml` and
  `FoiliOS/FoilIOS.xcodeproj/project.pbxproj`.
- The next release build should be `0.1.0 (11)`.
- v0.18, v0.19, v0.20, and v0.21 all have `status: done` and final audit
  receipts with `full_outcome_complete: true`.
- v0.19 proves build-10 live physical recording, provider transcription,
  keyboard insertion, and cleanup.
- v0.20 is a truthful pass/block host-app matrix expansion: Safari single-line
  passed; Mail, Calendar, and Foil secure fallback are exact blockers.
- v0.21 proves stale, malformed, exact-once, and post-insert safety with focused
  Swift tests plus physical WDA receipts.
- `xcodebuild -list -project FoiliOS/FoilIOS.xcodeproj` sees `FoilIOS`,
  `FoilKeyboard`, and `FoilIOSTests`.
- `xcodebuild -showdestinations` sees the physical `iPhone-preview`
  destination and simulator destinations.
- `scripts/ios-physical-harness.py status` sees `iPhone-preview`, `iproxy`, and
  the WDA project; WDA is not currently running.
- App Group summary is not currently readable from the device; copy-from failed
  with sanitized stdout/stderr hashes only. This is a pre-smoke cleanup/readiness
  issue, not proof of build 11.
- App Store Connect key material shape check found one `AuthKey_*.p8` under an
  altool search path, but no API key ID/issuer ID in environment or repo docs.
- `xcrun altool --list-apps --filter-bundle-id com.neonwatty.FoilIOS
  --output-format json` fails with the expected missing-authentication error:
  altool requires JWT `--api-key`/`--api-issuer` or username/app-password
  parameters.

## Recommendation

Proceed with a local release-prep Worker slice:

- bump source build from 10 to 11;
- regenerate the Xcode project;
- run focused simulator tests;
- archive/export build 11;
- inspect IPA metadata for both app and keyboard extension;
- record receipts and stop before upload.

Do not attempt TestFlight validation/upload until the operator supplies or
restores the App Store Connect API key ID and issuer ID without printing secret
material.

## Candidate Worker

Objective: prepare build 11 locally and prove the exported IPA app and keyboard
metadata both report `0.1.0 (11)`, stopping before upload.

Allowed files:

- `FoiliOS/project.yml`
- `FoiliOS/FoilIOS.xcodeproj/**`
- `docs/goals/ios-v0.22-testflight-release-proof/**`

Verify:

- `cd FoiliOS && xcodegen generate --spec project.yml`
- focused simulator tests for the iOS unit-test suite;
- archive/export build 11;
- IPA metadata inspection for containing app and keyboard extension;
- JSON/YAML parse for touched receipts;
- `git diff --check`;
- targeted secret/raw-content scan.

Stop if:

- Xcode signing/archive/export requires user account action;
- metadata does not show app and keyboard build 11;
- any command would print or commit credentials.
