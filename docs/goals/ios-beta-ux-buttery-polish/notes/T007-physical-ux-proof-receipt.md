# T007 Physical UX Proof Receipt

Date: 2026-06-19
Result: done

## Claim

The polished iOS beta path does not merely look ready: on iPhone-preview, the
current build shows route-first setup plainly, keeps the Mac route future-facing,
keeps provider verification narrowly worded, exposes safe target guidance, and
successfully performs the sterile record-return-keyboard-insert loop through
Foil Keyboard without duplicate insertion or stale/non-complete insertion.

## Strongest Realistic Failure Modes And Evidence

1. The app could say setup is ready while the route, provider, Full Access,
   keyboard health, or App Group state is still ambiguous.
   Evidence:
   - `physical/T007-preflight-healthy.json` proves iPhone-preview, WDA, tooling,
     and redaction self-test were healthy before host-app work.
   - `physical/T007-install-current-build.json` records the current branch and
     build `0.1.0 (13)` install metadata without raw install output.
   - `physical/T007-route-setup-ready-receipt.json` proves the route-first
     onboarding, iPhone API-key path, future Mac path, Advanced / Support gate,
     provider field, setup readiness summary, setup next action, tested-target
     guidance, dictation console, and `onboarding-ready` were present while
     `onboarding-not-ready` was absent. Its hashed text checks include the beta
     API-key path, Mac future-route warning, provider-verification caveat, narrow
     Full Access explanation, and tested-target guidance.

2. The keyboard could appear ready but insertion could fail, duplicate, or leave
   an insertable transcript behind.
   Evidence:
   - `physical/T007-reset-before-keyboard.json` and
     `physical/T007-app-group-idle-after-reset.json` prove the run started from
     idle/no transcript App Group state.
   - `physical/T007-stage-complete.json` and
     `physical/T007-app-group-staged-complete.json` prove a sterile complete
     transcript was staged with only hashes and lengths recorded.
   - `physical/T007-safari-fixture-loaded-receipt.json` proves the sterile Safari
     fixture loaded and the target phrase count was zero before insertion.
   - `physical/T007-safari-before-insert-receipt.json` proves Foil Keyboard was
     visible with `Insert latest` enabled before insertion.
   - `physical/T007-safari-after-insert-receipt.json` proves the sterile phrase
     appeared exactly once and `Insert latest` became disabled.
   - `physical/T007-app-group-after-insert.json` proves the App Group returned
     to idle/no transcript after insertion.
   - `physical/T007-safari-after-second-click-receipt.json` and
     `physical/T007-app-group-after-second-click.json` prove a second click did
     not duplicate insertion or rehydrate App Group transcript state.

3. Stale or non-complete keyboard state could still be insertable.
   Evidence:
   - `physical/T007-app-group-stale-staged.json` and
     `physical/T007-stale-disabled-receipt.json` prove a stale complete snapshot
     with a sterile transcript stayed non-insertable and did not change the
     target field.
   - `physical/T007-app-group-processing-staged.json` and
     `physical/T007-processing-disabled-receipt.json` prove a processing snapshot
     with a sterile transcript stayed non-insertable and did not change the
     target field.

4. Secure fields could accidentally look supported or consume a transcript.
   Evidence:
   - `physical/T007-stage-secure-transcript.json` and
     `physical/T007-app-group-secure-staged.json` prove a sterile transcript was
     staged before the secure-field check.
   - `physical/T007-secure-fixture-loaded-receipt.json` proves the sterile secure
     fixture loaded with the secure field empty.
   - `physical/T007-secure-field-rejection-receipt.json` proves Foil Keyboard and
     `Insert latest` were absent in the secure field and the staged secure phrase
     count remained zero.

5. Cleanup could leave stale state for the next tester.
   Evidence:
   - `physical/T007-reset-final.json` and
     `physical/T007-app-group-final-idle.json` prove final App Group state was
     reset to idle/no transcript.

## Privacy Audit

Committed receipts contain hashes, counts, boolean identifier presence, build
metadata, App Group phase, and pass/fail assertions only. Raw WDA trees,
screenshots, raw install/launch logs, audio, transcripts, provider keys, private
phone content, App Store Connect keys, JWTs, archives, and IPAs stayed out of
the repo.

## Residual Risk

This proof uses sterile Safari fixtures plus the current Foil app surface. It
does not add a new Notes or Messages receipt for this board; prior boards have
covered those rows, and this board's hard release-gate proof is the route/setup,
keyboard, exact-once, stale/processing, secure-field, and App Group loop on the
current polished build.
