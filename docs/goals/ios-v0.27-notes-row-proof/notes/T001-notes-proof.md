# T001 Notes Proof

## Result

`pass`

## Evidence

- `notes-sterile-precheck.json` proved WDA could inspect the operator-opened
  sterile Notes editor without printing raw source. It found one text input
  node plus Foil Keyboard in no-transcript state.
- `notes-stage-transcript.json` staged a sterile complete transcript using
  App Group writes that record only transcript hash/length.
- `notes-before-insert.json` proved Foil Keyboard root and Insert latest were
  present and Insert latest was enabled before insertion.
- The first tap at `{x: 207, y: 615}` did not hit the visible Notes Insert
  latest button; `notes-after-insert.json` failed and App Group stayed complete.
- A screenshot kept in `/tmp` showed the Notes keyboard button center around
  logical `y=657`.
- `notes-after-insert-retry.json` passed after tapping `{x: 207, y: 657}`:
  the sterile value appeared exactly once and Insert latest became disabled.
- `notes-app-group-after-insert-retry.json` proved App Group returned to
  `idle` with no transcript.

## Privacy Boundary

Raw WDA source and the screenshot stayed in `/tmp`. Committed receipts contain
hashes, booleans, identifier checks, text counts, and App Group summaries only.
