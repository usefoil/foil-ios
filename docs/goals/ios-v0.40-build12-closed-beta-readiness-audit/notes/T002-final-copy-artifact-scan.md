# T002 Final Copy And Artifact Scan

## Decision

`scan_pass_with_expected_negative_examples`

## `foil-ios` Current-Copy Scans

Passed:

- no stale build `0.1.0 (7-11)` or build 7-11 references in current iOS
  README/handoff/matrix/runbook surfaces
- no positive Mail support, Messages delivery, existing private-thread proof,
  public App Store availability, arbitrary app support, build 12 Notes pass, or
  build 12 Messages pass claims in current iOS README/handoff/matrix surfaces
- no raw WDA source JSON/XML, screenshots, or movies in the build-12 goal
  receipt set

## `foil` Site/SEO Scans

PR #287 updated the main `foil` site and SEO copy to align with build 12 proof:

- physical build 12 onboarding proof
- Safari normal-field insertion proof
- Safari secure-field rejection proof
- Notes/Messages need sterile surfaces before build 12 rerun
- Messages remains draft-only
- Mail remains deferred
- no broad iPhone app support or public App Store claim

PR #287 merged through the merge queue at commit
`195a2aa2cad28fbd9cd26e07baeb1b0cf9fadd0c`.

Remaining scan hits in `foil` are expected:

- `iOS keyboard works everywhere` appears in an explicit avoid/negative-example
  list.
- `Foil iOS solves all keyboard insertion issues` appears in an explicit
  avoid/negative-example list.
- `public App Store availability` appears in the landing page caveat sentence:
  "This is not broad iPhone app support or public App Store availability."

## Verdict

No current-facing copy or committed artifact found by the final scan blocks a
narrow internal build 12 invite.
