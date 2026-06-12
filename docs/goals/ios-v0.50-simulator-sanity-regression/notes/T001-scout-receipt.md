# T001 Scout Receipt - Simulator Sanity Regression

Date: 2026-06-09

## Claim

Foil iOS had simulator unit coverage and compile commands, but no named
closed-beta sanity lane that future boards could run consistently.

## Existing coverage

- `FoilDictationLoopPresentationTests` covers onboarding/setup copy, beta
  guidance, app loop states, keyboard idle/ready/failure/full-access/stale
  health states, and transcript review.
- `FoilKeyboardBridgeTests` covers exactly-once consumption, empty transcript,
  non-complete leftover transcript, and insertability rules.
- Provider, transcription client, and transcript-quality tests cover provider
  recovery presentation and deterministic API behavior.
- Generic iOS compile proves the app and keyboard extension build for device SDK
  without signing.

## Gap

The commands were known but not packaged as a reusable lane, and their proof
boundary was easy to overstate as physical host-app evidence.

## Proof strategy

Add a script that runs project listing, full simulator tests, and unsigned iOS
compile, while printing that the lane is simulator-only and does not prove
physical keyboard insertion or host-app behavior.
