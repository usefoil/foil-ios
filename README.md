# Foil iOS

Foil iOS is the native iPhone companion prototype for Foil-style dictation. It
contains a SwiftUI containing app plus a custom keyboard extension that hands
off recording/transcription through shared App Group state and inserts the
latest transcript into the focused host app.

This repository was split out of `mean-weasel/foil` so the iOS app can evolve
independently from the macOS menu bar app, with separate TestFlight, signing,
privacy, and physical-device automation workflows.

## Current Prototype

- Native iOS app target: `com.neonwatty.FoilIOS`
- Custom keyboard extension: `com.neonwatty.FoilIOS.Keyboard`
- App Group: `group.com.neonwatty.FoilIOS`
- Project generator: XcodeGen via `FoiliOS/project.yml`
- Current source version: `0.1.0 (13)`

The prototype supports:

- recording audio in the containing app;
- transcribing through the configured Groq-compatible provider;
- sharing transcript state with the keyboard extension;
- inserting the transcript exactly once with `Insert latest`;
- resetting stale shared state; and
- physical iPhone proof through sanitized WDA/App Group receipts.

## Layout

- `FoiliOS/` - XcodeGen spec, generated Xcode project, app, keyboard, shared
  code, and tests.
- `scripts/` - physical iPhone/WDA evidence helpers.
- `docs/` - iOS runbooks, TestFlight notes, host-app matrix, and acceptance
  evidence guidance.
- `docs/goals/` - GoalBuddy boards and receipts from the iOS prototype work.
- `.github/ISSUE_TEMPLATE/ios_beta_feedback.yml` - privacy-safe closed-beta
  feedback form.

## Build And Test

```bash
cd FoiliOS
xcodegen generate --spec project.yml
xcodebuild -list -project FoilIOS.xcodeproj
xcodebuild test -project FoilIOS.xcodeproj -scheme FoilIOS \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

Physical-device testing requires the local WDA setup described in
`docs/ios-physical-automation-runbook.md`.

Closed-beta feedback triage is documented in
`docs/ios-beta-feedback-triage.md`.

## Claim Boundary

The safe current released TestFlight claim is narrow: build `0.1.0 (13)` can
complete the route-first setup, record-in-Foil, return-to-keyboard, and
Insert-latest loop on a physical iPhone for the sterile Safari normal-field
fixture, and secure fields are expected to reject the custom keyboard. The
preview also has physical build 13 onboarding/setup proof, provider-route
readiness, keyboard-health recovery, App Group idle/no-transcript recovery, and
exact-once Safari insertion proof.

Do not claim arbitrary app support. Earlier builds proved sterile Notes
insertion and fake-recipient Messages draft insertion without sending, but the
current safe claim remains gated to sterile surfaces: Notes and Messages are
tester feedback targets only when a blank note or fake/dedicated draft is
prepared first. Messages delivery and existing private-thread behavior are not
claimed. Mail compose proof is intentionally deferred in
`https://github.com/usefoil/foil-ios/issues/12`. Full Access, keyboard
cycling, and host-app refresh friction remain expected beta caveats.
