# T001 Copy Inventory

## Stale Source

`docs/ios-testflight-feedback-v0.7.md` is historical build-7 copy. It conflicts
with the current v0.30 readiness state in three ways:

- build target is `0.1.0 (7)`, while current beta target is `0.1.0 (11)`;
- it says Messages is not tested, while v0.29 proves fake-recipient draft
  insertion without sending;
- it lacks the current Mail deferral issue `#12`.

## Current Replacement Facts

- v0.30 readiness decision: `go_narrow_internal_beta_with_caveats`.
- Current installed/source build: `0.1.0 (11)`.
- Proven tester rows: Notes, Safari normal text, Safari secure rejection,
  Messages fake-recipient draft insertion.
- Deferred: Mail blank compose, tracked at
  `https://github.com/mean-weasel/foil-ios/issues/12`.
- Unsupported claims: arbitrary iPhone app support, Mail support, Messages
  delivery, and existing private-thread behavior.

## Recommended Action

Create `docs/ios-closed-beta-tester-handoff.md` as the current tester handoff
and mark the v0.7 file as superseded rather than deleting historical evidence.
