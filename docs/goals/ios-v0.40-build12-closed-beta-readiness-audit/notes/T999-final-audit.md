# T999 Final Audit

## Recommendation

`invite_narrow_internal_beta`

Build `0.1.0 (12)` is ready for narrow internal TestFlight feedback, with the
invite framed around onboarding clarity, recording/transcription flow, keyboard
setup, Safari normal-field insertion, secure-field rejection, reset/recovery,
and tester friction.

Do not frame this as broad iPhone app support.

## Evidence Table

| Area | Result | Evidence |
| --- | --- | --- |
| TestFlight release | Go | v0.36 proves build 12 uploaded, valid, export-compliance safe, and attached to internal testers. |
| Physical install/onboarding | Go | v0.37 proves iPhone-preview installed build 12 and showed build 12 onboarding/setup/target/recovery guidance. |
| Safari normal insertion | Go | v0.38 proves exactly-once insertion and App Group idle after insert on build 12. |
| Safari secure field | Go | v0.38 proves Foil Keyboard absent, secure length zero, transcript preserved, and cleanup idle. |
| Notes | Hold row | v0.38 stopped before insertion because Notes opened to unknown existing content and no blank sterile editor path opened. |
| Messages | Hold row | v0.38 stopped before insertion because fake-recipient payloads landed on the private thread-list surface. |
| Mail | Hold row | Still deferred under issue #12. |
| Tester copy | Go | v0.39 updates README/handoff to build 12 and preserves blockers/caveats. |
| Landing/SEO copy | Go | `mean-weasel/foil` PR #287 merged and aligns public-facing iOS preview copy with build 12 evidence. |

## Strongest Failure Mode

The strongest realistic failure mode is over-inviting: testers could interpret
"build 12 ready" as meaning Foil Keyboard is proven across Notes, Messages,
Mail, existing private threads, secure fields, or arbitrary iPhone apps.

Evidence that rules it out:

- tester handoff safe claim limits build 12 host-app proof to Safari normal
  insertion and Safari secure-field rejection
- README says earlier Notes/Messages proof exists, but build 12 rerun stopped
  before insertion when sterile surfaces were unavailable
- main landing/SEO copy now says Notes/Messages need sterile surfaces before
  build 12 rerun, Messages remains draft-only, Mail is deferred, and there is
  no public App Store or broad app-support claim
- final scans found no stale build 11 current-copy hits, no positive Mail pass,
  no Messages delivery claim, no public App Store claim, and no raw WDA/source
  artifacts in build-12 receipts

## Invite Boundary

Invite internal testers only with this scope:

- install/update Foil Dictation build `0.1.0 (12)` from TestFlight
- complete keyboard setup and Allow Full Access
- test recording/transcription in Foil
- test Insert latest in safe fields, especially Safari normal fields or other
  deliberately sterile fields
- observe keyboard cycling/refocus and reset/recovery friction
- avoid private content, existing message threads, Mail, secure fields, and any
  claim of delivery

## Follow-Ups

- Add a reliable blank Notes creation path or operator setup recipe, then rerun
  the Notes build 12 row.
- Add a reliable sterile Messages compose path for iOS 26.5, then rerun the
  Messages draft-only build 12 row.
- Continue issue #12 for Mail compose proof.
