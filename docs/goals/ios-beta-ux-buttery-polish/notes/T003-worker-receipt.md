# T003 Worker Receipt - Provider Key Recovery

## Result

Done.

## Changes

- Changed saved-key copy so it does not imply live provider verification:
  - Credential summary now says the Groq key is saved on this iPhone and provider verification happens on the next transcription.
  - Setup readiness copy says a saved key is verified only after a successful transcription.
  - Setup-ready and onboarding-ready copy preserve the readiness gate while saying provider verification still depends on successful transcription.
- Added typed provider recovery classification:
  - Missing/rejected key paths are `updateProviderKey`.
  - Network, HTTP retryable, invalid response, missing recording, and generic failures remain retryable recovery paths.
- Made key-update failures foreground the key editor and avoid retry as the primary recovery:
  - The Recovery section shows the provider-key editor when a missing/rejected key caused failure.
  - Retry transcription is hidden for provider-key update failures.
  - The app-stage presenter shows "Update provider key" with no primary retry action for key-update failures.
- Kept key material out of UI and receipts.

## Verification

- PASS: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
  - Executed 34 tests, 0 failures.
- PASS: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilProviderFailurePresentationTests`
  - Executed 13 tests, 0 failures.
- PASS: `git diff --check`.
- PASS: GoalBuddy state checker before receipt update.
- PASS: privacy/key leakage scan over changed files.
  - Hits were limited to existing fake unit-test key/sentinel strings used for no-leak assertions and intended guardrail text in goal/state docs.
- PASS: provider overclaim scan.
  - Remaining provider-verification hits explicitly say verification still depends on successful transcription.

## Notes

- An initial presentation-test run failed because the setup-ready copy dropped the existing "narrow closed beta loop" wording. The copy was corrected to preserve that boundary and add the provider-verification qualifier.
- A parallel provider-test run exited before establishing the test connection while another suite was using the simulator. The provider suite passed on a solo rerun, so this was treated as simulator runner contention.

## Files

- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSApp/TranscriptionController.swift`
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `FoiliOS/FoilIOSTests/FoilProviderFailurePresentationTests.swift`
- `docs/goals/ios-beta-ux-buttery-polish/state.yaml`
- `docs/goals/ios-beta-ux-buttery-polish/notes/T003-worker-receipt.md`
