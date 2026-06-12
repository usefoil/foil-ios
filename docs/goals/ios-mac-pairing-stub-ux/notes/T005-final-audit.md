# T005 Judge: Final Audit

Verdict: ready for PR handoff.

## Evidence Table

| Failure mode | Evidence |
| --- | --- |
| Recommended **Use my Mac** falsely completes setup while the bridge is stubbed. | `testOnboardingReadinessNeverCompletesForStubbedMacRoute` passed in both the focused and full test runs. |
| Mac route copy drifts away from the shared contract names. | `testMacPairingPreviewExposesSharedContractNamesWithoutClaimingBridgeReady` passed and asserts `foil.localBridge`, `mac-selected`, `RouteReceipt`, `local-whisper-cpp`, `openai-whisper`, and `custom-openai-compatible`. |
| API-key-on-iPhone setup regresses while preserving the future Mac path. | `testRouteChoicesPutMacFirstButKeepIPhoneAPIKeyUsable` and `testOnboardingReadinessCompletesOnlyForHealthyIPhoneAPIKeyRoute` passed. |
| Full Access, keyboard health, App Group state, or insertion gates produce a false-ready state. | `testOnboardingReadinessDoesNotCompleteWhenAnyInsertionGateIsMissing`, keyboard health presentation tests, and the full `FoilIOSTests` run passed. |
| Exact-once insertion or stale/non-complete transcript recovery regresses. | Full `FoilIOSTests` run passed 43 tests, including `FoilKeyboardBridgeTests` for empty transcript ignore, non-complete leftovers, exact-once consume-and-clear, insertable transcript requirements, and legacy payload decode. |
| Diagnostics/fake transcript tools move into first-run setup. | `testAdvancedSupportItemsHideDiagnosticsAndFakeTranscriptTools` passed. |
| Secrets or private phone artifacts enter the branch. | `git diff --check` passed; broad scan found only expected fake unit-test strings, env var names, and guardrail prose; touched-file scan found no key-like values. |

## Verification Commands

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,id=8A7EA28F-4690-4816-B650-38648E6F44FB' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests CODE_SIGNING_ALLOWED=NO`
  passed 21 tests with 0 failures.
- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,id=8A7EA28F-4690-4816-B650-38648E6F44FB' CODE_SIGNING_ALLOWED=NO`
  passed 43 tests with 0 failures.
- `git diff --check` passed.
- Secret-pattern scans over broad and touched scopes did not find committed
  provider keys, App Store Connect keys, JWTs, raw private phone artifacts, or
  archive/IPA artifacts.

## Residual Risk

This slice does not implement real Mac pairing, Bonjour discovery, credential
offers, encryption, or cross-device route receipts. That is intentional: the
Mac route remains a truthful local stub and cannot satisfy onboarding readiness.
