# T001 Messages Attempt

## Result

`blocked_privacy`

## Evidence

- `messages-sterile-precheck.json` proved WDA could see Messages and Foil
  Keyboard, without printing raw WDA source.
- `messages-stage-transcript.json` staged a sterile transcript and recorded
  only hash/length.
- `messages-before-insert.json` proved Foil Keyboard root and Insert latest
  were enabled before insertion.
- A local-only screenshot was used to visually confirm the focused thread was
  not sterile. The screenshot was deleted from `/tmp` and was not committed.
- Insert latest was not tapped.
- `messages-privacy-cleanup.json` reset App Group back to idle/no transcript.
- `messages-privacy-blocker.json` records the stop condition.

## Privacy Boundary

No Messages insertion was attempted. Raw WDA source and screenshot artifacts
were deleted from `/tmp`. Committed receipts contain no message text, contacts,
phone numbers, screenshots, or raw source.

## Exact Unblock

Create or open a dedicated sterile self/test thread with no private prior
messages visible, focus the draft field, and switch to Foil Keyboard. Then rerun
the row.
