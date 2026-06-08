# T001 Matrix Protocol

## Current Automation State

`scripts/ios-physical-harness.py status` reports `iPhone-preview` present and
available, `iproxy` present, WDA project present, and `wda.ready=false`.

## Fresh v0.23 Transcript State

The TestFlight rehearsal left a fresh transcript staged for Foil Keyboard:

- `docs/goals/ios-v0.23-testflight-rehearsal/notes/receipts/command-mailbox-rehearsal.json`
- App Group after transcribe: `phase=complete`, `hasTranscript=true`,
  transcript hash `1210c267a9cf2826`, length `87`.

## Row Protocol

Every Apple app row needs the same proof shape:

1. Confirm the staged App Group transcript before the row.
2. Put the target app in a sterile editable field without inspecting private
   content.
3. Verify Foil Keyboard is active and `foil-keyboard-insert-latest` is enabled.
4. Trigger `Insert latest`.
5. Verify the sterile target text changed exactly once, and
   `foil-keyboard-insert-latest` is disabled or App Group is no longer staged.
6. Cleanup the draft/field/App Group state.
7. Commit only sanitized receipts: hashes, counts, booleans, identifiers, and
   phase names.

## Row-Specific Boundaries

| Row | Sterile target | Required automation | Current status |
| --- | --- | --- | --- |
| Notes | Fresh sterile note/editor | WDA or equivalent tap/snapshot to focus note, switch keyboard, tap insert, verify value count | Blocked: WDA unavailable |
| Messages/iMessage | Operator-opened sterile self/test thread input, no send | WDA current-app source only after sterile thread is focused; never navigate thread list | Blocked: WDA unavailable and sterile thread must be operator-confirmed |
| Mail | Sterile compose draft body, no send | WDA or equivalent to create/focus draft and verify no inbox/private content | Blocked: WDA unavailable; Mail account/surface must remain private-safe |
| Safari normal text | Local sterile fixture or safe blank text field | WDA or equivalent to focus field, activate Foil Keyboard, insert, verify value count | Blocked: WDA unavailable |
| Safari secure field | Local sterile secure fixture | WDA or equivalent to prove custom keyboard absence/no insertion | Blocked: WDA unavailable |

## Recommendation

Do not run T002-T005 until WDA or an equivalent physical UI-control route is
available. Command-mailbox proof is not host-app insertion proof.
