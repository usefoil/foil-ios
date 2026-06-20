# T999 Final Audit

Date: 2026-06-19
Decision: complete
Full outcome complete: true

## Summary

The Foil iOS beta UX buttery polish goal is complete. PRs #53 through #58
landed the scoped UX/documentation slices and the proof-mode decision, and this
branch adds sanitized physical iPhone-preview proof for the final route-first
setup and keyboard insertion experience.

## Evidence Map

1. Current beta path is unmistakable while Mac remains future-facing.
   - PR #53 foregrounded the iPhone API-key route and kept Mac visible as a
     future path.
   - `physical/T007-route-setup-ready-receipt.json` proves the current build
     exposes route-first onboarding, the iPhone API-key path, the future Mac
     route, Advanced / Support, and `onboarding-ready` without
     `onboarding-not-ready`.

2. Full Access and provider setup are plainly and narrowly explained.
   - PR #53 narrowed Full Access copy to Foil's shared transcript state.
   - PR #55 made saved key distinct from provider verification.
   - `physical/T007-route-setup-ready-receipt.json` includes hashed text checks
     for the narrow Full Access copy and provider-verification caveat.
   - `FoilProviderFailurePresentationTests` passed 13 tests with no failures.

3. Keyboard states guide the tester instead of producing dead ends.
   - PR #54 clarified idle, Full Access off, complete, inserted-once, stale,
     failed, and processing states.
   - PR #56 clarified aged processing and App Group recovery.
   - `physical/T007-stale-disabled-receipt.json` proves stale complete state is
     non-insertable.
   - `physical/T007-processing-disabled-receipt.json` proves processing state is
     non-insertable.
   - `FoilDictationLoopPresentationTests` passed 37 tests with no failures.

4. The record-return-keyboard-insert loop works physically and exactly once.
   - `physical/T007-safari-fixture-loaded-receipt.json` proves the sterile
     Safari target started empty.
   - `physical/T007-safari-before-insert-receipt.json` proves Foil Keyboard was
     visible with `Insert latest` enabled for a fresh complete transcript.
   - `physical/T007-safari-after-insert-receipt.json` proves the sterile phrase
     landed exactly once and `Insert latest` became disabled.
   - `physical/T007-safari-after-second-click-receipt.json` proves a second click
     did not duplicate insertion.
   - `FoilKeyboardBridgeTests` passed 8 tests with no failures.

5. Unsupported or sensitive targets do not overclaim support.
   - PR #53 and PR #57 made tested target guidance visible and kept broad host
     app support out of the beta claim.
   - `physical/T007-secure-field-rejection-receipt.json` proves Foil Keyboard
     and `Insert latest` are absent in the sterile secure field and the staged
     phrase remains absent.

6. App Group stale-state recovery is preserved.
   - `physical/T007-reset-before-keyboard.json` and
     `physical/T007-app-group-idle-after-reset.json` prove the proof run began
     from idle/no transcript state.
   - `physical/T007-app-group-after-insert.json`,
     `physical/T007-app-group-after-second-click.json`, and
     `physical/T007-app-group-final-idle.json` prove App Group state returned to
     idle/no transcript after insertion, second-click attempt, and final cleanup.

7. Docs and support surfaces match the current beta claim.
   - PR #57 aligned README, beta handoff, and the iOS feedback template with
     build `0.1.0 (13)` and narrow host-app boundaries.

## Commands

- `python3 scripts/ios-physical-harness.py preflight --strict --wda-url http://192.168.1.40:8100` passed with `classification: healthy`.
- `xcodebuild build -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -configuration Debug -destination 'id=00008030-001A0C980A33C02E' -derivedDataPath /tmp/foil-ios-beta-ux-t007-dd DEVELOPMENT_TEAM=B3A6AN2HA4 CODE_SIGN_STYLE=Automatic -allowProvisioningUpdates` passed.
- `xcrun devicectl device install app --device 5320F5AD-2A71-50AC-94FE-207B544B6247 /tmp/foil-ios-beta-ux-t007-dd/Build/Products/Debug-iphoneos/Foil iOS.app` passed; committed install receipt stores metadata and hashes only.
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests -only-testing:FoilIOSTests/FoilKeyboardBridgeTests -only-testing:FoilIOSTests/FoilProviderFailurePresentationTests` passed 58 tests, 0 failures.
- `git diff --check` passed.
- GoalBuddy state checker passed.
- Privacy/no-overclaim scan hit only guardrail text.

## Privacy Audit

Committed receipts contain hashes, counts, boolean identifier checks, App Group
phase, build metadata, and pass/fail assertions. Raw WDA trees, screenshots, raw
launch/install logs, audio, transcript bodies, provider keys, private phone
content, App Store Connect keys, JWTs, archives, and IPAs are not committed.

## Residual Risk

This board's new physical proof uses sterile Safari fixtures and the Foil app
surface. It does not re-run Notes or Messages on this branch; prior safe-path
boards have those rows, and this board's completion standard is satisfied by the
current route/setup, keyboard, exact-once, stale/processing, secure-field, and
App Group proof.
