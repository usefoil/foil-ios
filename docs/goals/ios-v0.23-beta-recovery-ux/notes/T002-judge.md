# T002 Judge

## Decision

`cleanup_slice_approved`

## Rationale

No product-code UX fix is justified by the v0.23 evidence. The only blocker is
external physical UI automation. However, the TestFlight rehearsal intentionally
left a transcript staged for keyboard insertion; since the matrix is blocked,
that staged transcript should be cleared to avoid future stale-state confusion.

## Approved Worker

T003 may reset the Foil App Group transcript state and record before/after
sanitized receipts. It may not edit product code.
