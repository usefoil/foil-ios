# T001 Hygiene Gate Map

## Branch And Required Contexts

Classic branch protection for `main` returns `Branch not protected` from:

```bash
gh api repos/usefoil/foil-ios/branches/main/protection
```

The active protection is a repository ruleset:

- Ruleset `18074403`, name `main-protection`, target `branch`, enforcement `active`.
- Condition includes the default branch: `~DEFAULT_BRANCH`.
- Rules include deletion protection, non-fast-forward protection, merge queue, required pull request, and required status checks.
- Merge queue is active with `ALLGREEN`, `max_entries_to_build=5`, `max_entries_to_merge=5`, `min_entries_to_merge=1`, wait `5` minutes, merge method `MERGE`.
- Required status checks are exactly:
  - `Hosted simulator sanity`
  - `Repo hygiene ratchet`
- Strict required status checks policy is enabled.

CodeQL runs on PRs but is not currently listed in the ruleset required-status-check contexts.

## Current CI Gate Inventory

Workflow: `.github/workflows/ios-simulator-sanity.yml`

Required job `Hosted simulator sanity`:

- Runs on `pull_request`, `push` to `main`, `merge_group`, and `workflow_dispatch`.
- Selects a hosted iPhone simulator destination.
- Installs pinned XcodeGen `2.45.4` with SHA256 verification.
- Regenerates the Xcode project and fails on generated project drift for `FoiliOS/FoilIOS.xcodeproj`, app generated plist, and keyboard generated plist.
- Runs `scripts/ios-simulator-sanity.sh` with hosted reset/preboot, two simulator-test attempts, 600s per test attempt, and 120s reset substep timeout.

Required job `Repo hygiene ratchet`:

- Runs `scripts/source-whitespace-check.py`.
- Runs Python bytecode compile for physical harness scripts and hygiene scripts.
- Runs fixture-only `scripts/ios-physical-harness.py self-test`.
- Runs `scripts/source-line-ratchet.py` text report and JSON report.
- Uploads narrow text/JSON artifacts only on failure.

## Current Max-Lines State

`scripts/source-line-ratchet.py --json` reports:

- `max_lines`: 500
- `allowlist_baselines`: `{}`
- `total_files`: 44
- `violations`: `[]`
- largest counted files:
  - `FoiliOS/FoilIOSApp/ContentView.swift`: 480
  - `FoiliOS/Shared/FoilKeyboardBridge.swift`: 445
  - `scripts/ios-physical-wda-evidence.py`: 367
  - `FoiliOS/Shared/FoilDictationLoopSetupPresenter.swift`: 338
  - `FoiliOS/FoilIOSApp/FoilOnboardingPanels.swift`: 335

This means the max-lines rule is already hard at the 500-line ceiling. The earlier migration allowlist is gone.

## Local Verification Run During Scout

Commands passed:

```bash
scripts/source-line-ratchet.py --json
scripts/source-whitespace-check.py
python3 -m py_compile scripts/ios-physical-harness.py scripts/ios_physical_harness/*.py scripts/ios-physical-wda-evidence.py scripts/source-whitespace-check.py scripts/source-line-ratchet.py
scripts/ios-physical-harness.py self-test
```

Latest `main` workflow evidence:

- Merge-group run `28140251354` for PR #64 passed `Repo hygiene ratchet` and `Hosted simulator sanity`.
- Push run `28140430889` on `main` at merge commit `9b4869ce9b1dc9c3ba45adae85cde55a55f76bbc` passed `Repo hygiene ratchet` and `Hosted simulator sanity`.
- Older push run `28139351433` failed `Hosted simulator sanity` after PR #66, but a later PR #64 merge-group run and `main` push run passed on current `main`.

## Gaps

1. The max-lines gate is hard, but `scripts/source-line-ratchet.py` has no fixture self-test proving fail-closed behavior for over-limit files, missing allowlist baselines, and allowlisted files that exceed their baseline.
2. The whitespace scanner is required, but `scripts/source-whitespace-check.py` has no fixture self-test proving trailing spaces/tabs fail while binary files and clean text pass.
3. The required-context docs mention job names, but they do not record that current enforcement lives in repository ruleset `main-protection`, not classic branch protection.
4. The repo has no single local command that tests the hygiene scripts' own fixture behavior before running them on the real checkout.

## Recommended Worker Package

Add deterministic fixture self-tests for the two hygiene scripts, wire those self-tests into the required `Repo hygiene ratchet` job, and document the current ruleset-required contexts plus the hard 500-line policy.

Suggested allowed files:

- `scripts/source-line-ratchet.py`
- `scripts/source-whitespace-check.py`
- `.github/workflows/ios-simulator-sanity.yml`
- `docs/ci-workflow-development-plan.md`
- `docs/ios-simulator-sanity-runbook.md`
- `docs/goals/foil-ios-hard-hygiene-gates-v2/state.yaml`

Suggested verification:

```bash
python3 -m py_compile scripts/source-line-ratchet.py scripts/source-whitespace-check.py
scripts/source-line-ratchet.py --self-test
scripts/source-whitespace-check.py --self-test
scripts/source-line-ratchet.py --json
scripts/source-whitespace-check.py
scripts/ios-physical-harness.py self-test
git diff --check
node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.9/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/foil-ios-hard-hygiene-gates-v2/state.yaml
```

Stop if the self-test implementation needs broad new dependencies, changes the real checkout scan semantics, weakens the max-lines ceiling, or changes required hosted simulator behavior.
