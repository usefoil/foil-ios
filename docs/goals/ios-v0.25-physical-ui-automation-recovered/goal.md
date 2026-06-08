# Foil iOS v0.25 Physical UI Automation Recovered

## Original Request

Retry WDA after the preview iPhone looked healthy and was unlocked.

## Outcome

Physical WDA automation is available through the direct device URL printed by
WDA, not localhost.

## Oracle

This goal is complete when WDA status, session creation, source fetch, and one
safe tap command are proven with sanitized receipts.

## Next Step

Run the Apple host-app insertion matrix using
`--wda-url http://192.168.1.40:8100` after a sterile target field is open.
