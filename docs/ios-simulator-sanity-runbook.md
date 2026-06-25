# Foil iOS Simulator Sanity Runbook

Use this lane before slower physical iPhone boards and before release
rehearsal. It is intentionally simulator-only.

```bash
scripts/ios-simulator-sanity.sh
```

GitHub Actions rollout and repo-hygiene gates are tracked in
`docs/ci-workflow-development-plan.md`, including the migration path toward a
required hard max-lines-per-file rule.

The repo-hygiene job uses `scripts/source-whitespace-check.py` to scan tracked
text files directly; this avoids the false confidence of `git diff --check` on
a clean hosted checkout.

The hosted workflow is named `iOS Simulator Sanity (non-physical)`. Required
status checks are enforced by the repository ruleset `main-protection`, not
classic branch protection. The required job contexts are:

- `Hosted simulator sanity`
- `Repo hygiene ratchet`

`Repo hygiene ratchet` runs fixture self-tests for the source whitespace scanner
and max-lines ratchet before scanning the real checkout, so those required gates
prove both their own fail-closed behavior and the current repo contents.

The lane runs:

- `xcodebuild -list` for project/scheme visibility;
- the full `FoilIOS` simulator test suite on `iPhone 17` by default;
- unsigned generic iOS compile to ensure the app and keyboard extension build
  for device SDK without requiring signing.

The script prints phase-level diagnostics before and after each internal
command:

- `project-scheme-visibility`
- `simulator-tests`
- `unsigned-generic-ios-build`

Each phase has a script-owned timeout so hosted CI can upload the existing text
artifact before the overall GitHub job timeout cancels the runner. Override
timeouts when debugging unusually slow runners:

```bash
IOS_SIMULATOR_SANITY_TEST_TIMEOUT_SECONDS=1800 \
  scripts/ios-simulator-sanity.sh
```

Hosted GitHub Actions resets and boots the selected simulator before the test
phase with bounded `simctl` sub-steps, then retries `simulator-tests` once only
if the first attempt exits with the script-owned timeout code `124`. The retry
is intentionally narrow: build failures, test assertion failures,
project/scheme visibility failures, simulator reset failures, and unsigned
generic iOS build failures still fail immediately. The text artifact records
`attempt-start`, `timeout`, `retry`, and `simulator-reset` lines when this path
is used.

Override the retry and reset behavior when reproducing hosted flakiness:

```bash
IOS_SIMULATOR_SANITY_RESET_BEFORE_TESTS=1 \
IOS_SIMULATOR_SANITY_RESET_TIMEOUT_SECONDS=120 \
IOS_SIMULATOR_SANITY_TEST_ATTEMPTS=2 \
IOS_SIMULATOR_SANITY_TEST_TIMEOUT_SECONDS=600 \
  scripts/ios-simulator-sanity.sh
```

Override the simulator destination when needed:

```bash
IOS_SIMULATOR_DESTINATION='platform=iOS Simulator,name=iPhone 16' \
  scripts/ios-simulator-sanity.sh
```

## Proof Boundary

Passing this lane means the app, keyboard extension, shared bridge, provider
presentation, transcript quality checks, and keyboard-state fixtures compiled
and passed deterministic simulator tests.

It does not prove:

- physical iPhone install/update;
- custom keyboard availability in a host app;
- Settings or Allow Full Access behavior;
- microphone permission on the preview phone;
- host-app insertion into Safari, Notes, Messages, Reminders, Mail, or secure
  fields.

Use `scripts/ios-physical-harness.py preflight --strict` and the physical
host-app matrix receipts for those claims.
