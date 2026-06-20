# T005 Worker Receipt - Beta Docs And Feedback Alignment

## Result

Done.

## Changes

- Updated README claim boundary from build `0.1.0 (12)` to build `0.1.0 (13)`.
- Replaced stale `mean-weasel/foil-ios` issue URL with `usefoil/foil-ios`.
- Kept host-app claims narrow:
  - Safari normal-field fixture remains the proven exact-once insertion claim.
  - Secure fields remain expected rejection.
  - Notes and Messages remain tester feedback targets only when a blank note or fake/dedicated draft is prepared first.
  - Messages delivery, existing private-thread behavior, Mail support, and arbitrary app support remain explicitly unclaimed.
- Updated the closed-beta handoff recovery section for:
  - missing/rejected provider key,
  - stuck processing,
  - App Group/shared-state failure,
  - Ready/no-transcript verification after reset.
- Updated the GitHub iOS beta feedback template:
  - build example now uses `0.1.0 (13)`,
  - setup asks whether provider key was verified by successful transcription,
  - failure/recovery choices include provider-key, stuck-processing, and App Group/shared-state recovery.

## Verification

- PASS: `rg -n "0\\.1\\.0 \\(12\\)|build 12|Build 12|mean-weasel/foil-ios" README.md docs/ios-closed-beta-tester-handoff.md .github/ISSUE_TEMPLATE/ios_beta_feedback.yml || true`
  - No hits in edited current tester-facing surfaces.
- PASS: `ruby -e 'require "yaml"; YAML.load_file(".github/ISSUE_TEMPLATE/ios_beta_feedback.yml"); puts "yaml ok"'`
- PASS: `git diff --check`.
- PASS: GoalBuddy state checker before receipt update.
- PASS: privacy/no-overclaim scan over edited surfaces.
  - Hits were negative guardrails only: no private transcript/screenshots/provider keys, no arbitrary iPhone app support, no Mail support, no Messages delivery, and no existing private-thread claim.
- BROAD HISTORICAL SCAN REVIEWED: `rg -n "0\\.1\\.0 \\(12\\)|build 12|Build 12" README.md docs .github/ISSUE_TEMPLATE/ios_beta_feedback.yml`
  - Remaining hits are historical host-app matrix rows, archived build-12 boards/receipts, and this board's T000 critique/verify text. Current README, handoff, and feedback template are clean.

## Files

- `README.md`
- `docs/ios-closed-beta-tester-handoff.md`
- `.github/ISSUE_TEMPLATE/ios_beta_feedback.yml`
- `docs/goals/ios-beta-ux-buttery-polish/state.yaml`
- `docs/goals/ios-beta-ux-buttery-polish/notes/T005-worker-receipt.md`
