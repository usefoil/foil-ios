# T002 Judge - Release Readiness Decision

## Decision

Release is not approved yet. Local build-11 release prep is approved.

## Reasoning

The tranche is source-ready: v0.18-v0.21 are complete and the project is
readable/buildable. However, the full board oracle requires TestFlight upload,
attachment, install/update on `iPhone-preview`, installed-build metadata, and a
physical smoke on that exact TestFlight build.

That full release path is currently blocked by missing App Store Connect
authentication parameters: an `AuthKey_*.p8` file exists, but `altool` has no
API key ID and issuer ID in the current environment or repo docs. Upload work
must not proceed by guessing or printing credentials.

## Approved Worker Slice

Worker T003 should do the largest safe local slice:

- bump build metadata from 10 to 11;
- regenerate the Xcode project;
- run focused simulator tests;
- archive/export the IPA;
- prove the app and keyboard extension IPA metadata both report `0.1.0 (11)`;
- record receipts.

## Stop Conditions

- Stop before App Store Connect validation/upload unless API key ID and issuer
  ID are restored through a safe local source.
- Stop if archive/export requires interactive Apple account action.
- Stop if generated artifacts contain secrets or if metadata mismatches.

## Full Outcome

`full_outcome_complete: false`

This board remains active after local build-11 prep. The follow-up release
Worker must validate/upload/attach/install/smoke-test build 11 once App Store
Connect authentication is available.
