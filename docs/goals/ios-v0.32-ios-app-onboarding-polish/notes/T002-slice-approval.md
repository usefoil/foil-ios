# T002 Slice Approval

## Decision

Approve a bounded presenter-plus-SwiftUI layout slice.

## Worker Scope

Allowed files:

- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `docs/goals/ios-v0.32-ios-app-onboarding-polish/**`

Do not touch:

- entitlements, bundle IDs, signing, TestFlight metadata, or provider/storage
  behavior;
- keyboard insertion behavior;
- physical-device automation harnesses.

## Required Behavior

- Add presenter-owned onboarding/checklist items for provider key,
  microphone, keyboard install, Full Access, record, return/insert, and reset.
- Add presenter-owned beta guidance for safe targets and caveats:
  Notes/Safari safe fields, Messages draft only/no send, Mail deferred, secure
  fields expected rejection, no broad arbitrary-app claim.
- Render these in `ContentView` with stable, scan-friendly accessibility
  identifiers.
- Preserve existing dictation, transcript review, keyboard health, and recovery
  behavior.

## Required Proof

Use TDD:

1. Add focused failing tests in
   `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`.
2. Run the focused test command and record the red failure.
3. Implement the smallest code needed.
4. Run focused tests again and then full iOS tests/build proof.

Test commands:

- `xcodebuild test -project FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
- `xcodebuild test -project FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17'`
- `xcodebuild build -project FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17'`

Stop if implementation requires a new TestFlight build before local proof,
private target-app inspection, unsupported deep links, or a broader product
claim than the v0.30 narrow beta boundary.
