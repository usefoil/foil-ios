# T002 Copy And Claim Boundary Scan

Date: 2026-06-12T02:26Z
Result: `done`
Decision: `pass_after_companion_public_copy_fix`

## iOS Repo

Scanned:

- `README.md`
- `docs/ios-closed-beta-tester-handoff.md`
- `docs/ios-keyboard-host-app-matrix.md`
- `docs/ios-testflight-upload-runbook.md`
- `docs/ios-testflight-feedback-v0.7.md`
- `.github/ISSUE_TEMPLATE/ios_beta_feedback.yml`

Findings:

- `README.md` keeps the broad claim boundary narrow: sterile Safari normal-field proof, secure-field rejection, no arbitrary app support, no Messages delivery/private-thread claim, and Mail deferred.
- `docs/ios-closed-beta-tester-handoff.md` now targets build `0.1.0 (13)` and says the build is uploaded/processed/attached/installed only because the later TestFlight physical-gate receipts prove those states. It still explicitly rejects broad iPhone compatibility, Mail support, Messages delivery, private-thread behavior, secure-field insertion, and public App Store availability.
- `docs/ios-keyboard-host-app-matrix.md` keeps build 12 Notes and Messages rows privacy-blocked and keeps v0.47 current-build rows blocked/not-rerun.
- `docs/ios-testflight-upload-runbook.md` records the later successful App Store Connect/TestFlight path, including the residual need for human TestFlight/App Store authentication where applicable.
- The beta issue template asks for safe target-app context and includes private-content guardrails.
- A scoped current-copy overclaim scan returned build-13 TestFlight claims in the handoff/runbook that are backed by `docs/goals/ios-testflight-readiness-physical-gate/state.yaml`, plus anti-claim lines for Messages delivery, Mail support, broad iPhone compatibility, and unsupported private-thread behavior.

## Public Foil Repo

Initial scan found stale phrasing in the public `usefoil/foil` repo that could be read as more general iOS verification than the evidence supports. Companion PR [usefoil/foil#288](https://github.com/usefoil/foil/pull/288) changed the wording to build-scoped host-app proof and merged at `2026-06-09T13:34:45Z` with merge commit `927e4289a1044f2f6848134256a603fd5952c9c4`.

Post-merge public scan confirmed:

- `site/index.html` calls Foil for iPhone a closed internal beta, not a public iOS app.
- `site/index.html` names build 12 onboarding, Safari normal insertion, and Safari secure-field rejection as the proven rows.
- `site/index.html` says Notes needs a blank sterile editor, Messages needs a fake/dedicated draft with no send proof, Mail is deferred, and the preview is not broad iPhone app support or public App Store availability.
- SEO/blog copy in `site/blog/**` and `docs/seo/**` now says `build-scoped host-app proof only`.
- The remaining public scan hits were build-scoped proof language or explicit negative caveats, not positive support claims.

## Decision

Tester-facing and public-facing copy is aligned with proven behavior after the companion public-copy merge and later TestFlight physical-gate receipts. No remaining scanned copy should invite a reader to infer Mail support, Messages delivery, existing private-thread safety, secure-field support, broad iPhone compatibility, or public App Store availability.
