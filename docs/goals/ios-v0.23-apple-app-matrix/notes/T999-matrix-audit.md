# T999 Matrix Audit

## Decision

`external_blocker`

## Matrix Result

All required Apple baseline rows are represented, but none can be freshly proven
in v0.23 while physical UI automation is unavailable.

| Row | v0.23 status | Reason |
| --- | --- | --- |
| Notes | Blocked | Cannot focus sterile note, verify Foil Keyboard, tap Insert latest, or verify exact-once mutation without WDA/equivalent UI control. |
| Messages/iMessage | Blocked | Requires operator-opened sterile thread and WDA/equivalent current-app inspection; no private thread list may be inspected. |
| Mail | Blocked | Requires sterile compose path and WDA/equivalent UI control; private inbox/account surfaces must not be inspected. |
| Safari text field | Blocked | Requires sterile fixture focus, keyboard state inspection, insert tap, and value-count verification. |
| Safari secure field | Blocked | Requires sterile fixture focus and UI evidence that custom keyboard is absent/no insertion occurs. |

## Strongest Realistic Failure Mode

The command-mailbox TestFlight proof could be mistaken for Apple host-app
insertion proof.

## Evidence That Rules It Out

- T001 records `wda.ready=false`.
- T002-T005 are blocked before opening host apps or inspecting private content.
- No Notes, Messages, Mail, or Safari row claims insertion.
- The staged transcript remains app-side proof only.

## Handoff

Route this to the beta recovery/UX board as an external automation blocker, not
as a product UX bug. The next useful action is restoring WDA or another physical
UI-control route.
