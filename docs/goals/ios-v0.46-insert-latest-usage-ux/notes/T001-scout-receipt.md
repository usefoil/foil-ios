# T001 Scout Receipt - Insert Latest Usage UX

Date: 2026-06-09

## Claim

Insert Latest has two separable risk layers:

- shared-state correctness in `FoilKeyboardBridge`;
- host-app/keyboard UI correctness in a real focused text field.

## Strongest realistic failure modes

1. A complete transcript remains insertable after it is stale, so a tester can
   accidentally insert old text.
2. A non-complete snapshot with leftover transcript text advertises Insert
   Latest.
3. A transcript that inserts once remains staged and can insert a second time.
4. Local bridge/presenter tests pass while the physical keyboard button or host
   field behaves differently.

## Proof strategy

- Add deterministic bridge tests for fresh, already-consumed, non-complete,
  empty, and stale transcript snapshots.
- Add presenter tests proving stale complete snapshots do not advertise
  `Insert latest`.
- Keep the physical host-field proof separate. It must use a sterile field,
  sanitized App Group hashes/state, and no private transcript text.

## Residual risk

The exact keyboard tap and intended-field mutation still require physical WDA or
equivalent UI automation. Simulator/unit proof cannot replace that oracle.
