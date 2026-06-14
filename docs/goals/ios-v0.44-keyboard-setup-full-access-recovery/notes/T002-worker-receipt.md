# T002 Worker Receipt

Result: done

Polished keyboard setup and recovery copy for the common closed-beta failure
mode where testers enable Full Access, return to a target app, and still need to
refocus the field or cycle keyboards before Foil Keyboard refreshes.

Changes:

- Setup checklist now explicitly says to choose Foil Keyboard after Add New
  Keyboard.
- Full Access recovery now says to refocus the target field and use
  globe/Next Keyboard to return to Foil Keyboard.
- Unverified and stale keyboard health recovery steps now name safe text fields,
  field refocus, and the globe/Next Keyboard cycle.
- Tester handoff recovery copy now uses the same language.

Verification:

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests` passed 15 tests.
- `git diff --check` passed.
- `scripts/ios-physical-harness.py status` found `iPhone-preview` present, but
  WDA not ready at `http://127.0.0.1:8100`.

This local copy/test polish does not prove the physical Settings or keyboard
cycling path.
