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
- Current source version: `0.1.0 (10)`

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

## Claim Boundary

The safe current claim is narrow: the iOS prototype can complete an
app-to-keyboard dictation loop on a physical iPhone for sterile/safe text
targets, with known keyboard-extension friction around Full Access, keyboard
cycling, and host-app refresh behavior.

Do not claim arbitrary app support. Secure fields are expected to reject custom
keyboards. Messages support is only proven for an operator-prepared sterile
thread.
