# T006 Judge Decision - Final UX Proof Mode

## Decision

Physical iPhone proof is required for final completion if the preview device and
WDA are available.

Simulator/unit proof is sufficient for the merged PR slices themselves because
T001-T005 were scoped presentation, bridge, provider-recovery, and docs changes
with focused tests and CI. It is not sufficient for the full owner outcome:
a first-time beta tester should experience a smooth route-first setup and
record-return-keyboard-insert loop without false-ready states.

## Why

The strongest realistic failure mode is user-facing, not purely model-level:
the app could have correct presenter tests while a real tester still sees stale
keyboard health, Full Access ambiguity, provider-key recovery friction, App
Group recovery confusion, host-app privacy risk, secure-field behavior, or an
Insert latest state that does not match actual keyboard behavior.

`docs/acceptance-evidence.md` calls for stronger proof for onboarding, visible
app UI, provider/API-key, keyboard insertion, and release/beta-facing changes.
For this board, the final proof should therefore include a physical walkthrough
when possible, using only sterile host surfaces and sanitized receipts.

## T007 Physical Receipt Script

Use only sterile surfaces. Do not commit raw WDA trees, screenshots, transcripts,
audio, provider keys, private app content, archives, IPAs, App Store Connect
keys, or JWTs.

Collect sanitized receipts for:

1. Build and app metadata: bundle id, version/build, commit/branch if available,
   WDA health, and device availability. Do not include private device content.
2. Route-first setup surface:
   - iPhone API-key route is current/default beta path.
   - Mac route remains visible but future-facing/not complete.
   - Advanced / Support holds diagnostics/fake transcript tools.
3. Setup readiness gates:
   - setup does not complete when keyboard health is stale or Full Access is not
     verified;
   - setup complete only after route, provider-key presence, microphone,
     keyboard health, Full Access, and App Group idle/no-transcript state are
     ready.
4. Provider recovery:
   - saved key copy does not claim provider verification;
   - missing/rejected provider key recovery points to updating the key before
     retrying;
   - no provider key material appears in committed receipts.
5. App Group and processing recovery:
   - stuck/aged processing is non-insertable and offers retry/reset;
   - App Group failure/recovery path names reset and Ready/no-transcript
     verification.
6. Keyboard state matrix in a sterile text field:
   - idle/no transcript;
   - processing/non-insertable;
   - complete/Insert latest once;
   - inserted-once/disabled afterwards;
   - stale or reset recovery if feasible without private data.
7. Host-app safety:
   - Safari normal sterile field exact-once insertion;
   - Safari secure/password field rejects Foil Keyboard and does not consume
     the transcript;
   - blank Notes or user-prepared Messages draft only if already sterile and
     safe; otherwise record an exact privacy blocker and skip.
8. Final cleanup:
   - App Group returns idle/no transcript;
   - no staged transcript remains;
   - committed receipt contains only hashes, counts, boolean identifiers, build
     metadata, and pass/fail assertions.

## If Physical Proof Is Blocked

If WDA or the preview device is unavailable, T007 may record an exact blocker
with sanitized evidence and run the strongest simulator/UI-inspection proof
available. The final T999 audit must then be `not_complete` for physical UX
proof unless the owner explicitly accepts simulator-only proof.
