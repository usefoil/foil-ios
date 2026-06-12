# T004 Worker: Regression Checks

## Summary

Re-ran the focused route/readiness suite and broadened the check to all local
Foil iOS unit tests. The broader run includes the keyboard bridge exact-once
and stale/non-complete transcript recovery tests, so it directly covers the
main regression risk for this slice.

## Evidence

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,id=8A7EA28F-4690-4816-B650-38648E6F44FB' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests CODE_SIGNING_ALLOWED=NO`
  passed 21 tests with 0 failures.
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,id=8A7EA28F-4690-4816-B650-38648E6F44FB' CODE_SIGNING_ALLOWED=NO`
  passed 43 tests with 0 failures.
- `git diff --check` passed.
- A broad secret scan over `FoiliOS` and `docs` produced only expected fake
  unit-test keys, environment-variable names, and documentation guardrails.
- A touched-file secret scan produced only this board's privacy sentence naming
  forbidden artifact classes; no key-like values were found in touched product,
  test, or board files.

## Physical / Simulator Scope

No physical smoke was added for this slice. The change is a presenter-level
stub seam and copy handoff, and the local simulator unit run exercises the app
target plus the exact-once/stale-state bridge tests without creating private
phone artifacts.

## Privacy

No provider keys, App Store Connect keys, JWTs, raw WDA trees, screenshots,
private phone content, archives, or IPA artifacts were created or printed.
