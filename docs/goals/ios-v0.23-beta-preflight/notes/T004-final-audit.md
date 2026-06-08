# T004 Final Preflight Audit

## Decision

`proceed_to_testflight_rehearsal_with_wda_limitation`

## What Is Proven

- Device is reachable and unlocked enough for CoreDevice operations.
- Installed Foil iOS metadata is known: `com.neonwatty.FoilIOS`, version `0.1.0`,
  bundle version `11`.
- App Group storage is readable/writable and can be reset to idle/no transcript.
- Keyboard health/full access is known from Foil-owned App Group preferences:
  `fullAccessState=enabled`.
- Current microphone plus provider/key readiness is proven by the
  command-mailbox recording/transcription proof. A sterile phrase produced a
  fresh App Group transcript with `phase=complete`, `hasTranscript=true`, and
  transcript length/hash only committed.
- Final cleanup returned App Group state to `idle`, `hasTranscript=false`.

## What Remains Blocked

- WDA/physical UI automation is still unavailable. It failed twice with XCTest
  `Timed out while enabling automation mode`.
- XcodeBuildMCP UI tools in this session are simulator-scoped and do not provide
  physical-phone tap/snapshot control.

## Strongest Realistic Failure Mode

The team could mistake command-mailbox app-side proof for keyboard/host-app UI
proof and proceed into the Apple app matrix without a way to tap or inspect
Notes, Messages, Mail, or Safari.

## Evidence That Rules It Out

- `notes/receipts/command-mailbox-proof.json` explicitly records
  `wdaStillUnavailable=true`.
- This audit permits the TestFlight rehearsal board to use the app-side
  command-mailbox path, but it does not permit the Apple app matrix to claim
  host-app insertion until WDA or an equivalent UI-control route is restored.

## Next Board

Proceed to `docs/goals/ios-v0.23-testflight-rehearsal/goal.md` for app-side
installed-build plus fresh sterile transcript proof.
