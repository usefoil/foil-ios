# T002 Worker Receipt - Insert Latest Usage UX

Date: 2026-06-09

## Claim

Foil now treats Insert Latest as fresh-only and exactly-once at the shared-state
layer, and the keyboard presentation gives stale complete transcripts a clear
non-insertable state.

## Changes

- `FoilKeyboardSnapshot.insertableTranscript(now:staleAfter:)` now rejects stale
  complete transcripts in addition to non-complete and empty snapshots.
- `FoilKeyboardBridge.consumeTranscriptForInsertion(now:staleAfter:)` uses the
  same freshness rule and clears shared state after each insert attempt.
- `KeyboardViewController` enables Insert Latest from the freshness-aware
  insertability check.
- `FoilDictationLoopPresenter.keyboardPresentation(...)` presents stale complete
  snapshots as `Transcript may be stale` with a `Stale transcript` button title,
  not `Insert latest`.

## Evidence

- Red run:
  `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilKeyboardBridgeTests -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
  failed because the bridge had no time-aware consume API and
  `insertableTranscript` was only a property.
- Green focused run:
  `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilKeyboardBridgeTests -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`
  passed 22 tests.

## Residual risk

This proves bridge and presentation behavior, not physical keyboard insertion
into a host app. That proof remains the judge blocker.
