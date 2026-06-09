# T002 Handoff Worker

## Decision

`copy_updated_for_build12`

## Changes

Updated `docs/ios-closed-beta-tester-handoff.md`:

- beta target is now `0.1.0 (12)`
- proven section names build 12 TestFlight availability, physical onboarding,
  Safari normal insertion, and Safari secure-field rejection
- Notes and Messages are described as earlier proven rows whose build 12 rerun
  stopped before insertion when sterile surfaces were unavailable
- Notes task now says to skip if Notes opens to existing content
- safe claim now names build 12 and limits build 12 host-app proof to Safari
  normal insertion and Safari secure-field rejection

Updated `README.md`:

- current source version is now `0.1.0 (12)`
- claim boundary names build 12 Safari fixture proof and build 12 onboarding
  proof
- Notes/Messages are described as earlier proof, with build 12 rerun blockers
- Mail, Messages delivery, existing private-thread behavior, and arbitrary app
  support remain out of scope

## Scan Results

`build12-copy-scan.json` records:

- stale build 11 scan: pass
- overclaim scan: pass
- positive build 12/caveat scan: pass

## Privacy Boundary

No screenshots, tester content, private phone content, credentials, or raw WDA
source were added.
