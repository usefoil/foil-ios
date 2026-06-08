# T999 Final Audit

## Decision

`notes_row_pass`

## Strongest Realistic Failure Mode

The keyboard might consume the staged transcript and clear App Group state
without actually mutating the Notes editor.

## Evidence That Rules It Out

- The failed first tap is preserved: `notes-after-insert.json` failed and App
  Group stayed `complete`, proving the row did not pass merely because a tap was
  attempted.
- The corrected retry passed:
  `notes-after-insert-retry.json` proves the sterile value count is exactly `1`
  and Insert latest is disabled.
- `notes-app-group-after-insert-retry.json` proves App Group cleanup to
  `idle` with no transcript after the successful insertion.

## Matrix Impact

The physical Apple host-app matrix now has fresh passes for:

- Safari normal field
- Safari secure field rejection
- Notes sterile editor

Messages and Mail remain blocked until operator-opened sterile fields are
available.
