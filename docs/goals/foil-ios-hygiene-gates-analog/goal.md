# Foil iOS Hygiene Gates Analog

## Original Request

After landing the honest GitHub Actions simulator-safe CI layer and the 350-line hard source ratchet, continue into the iOS analog of the standard TypeScript hygiene stack used in projects like `mean-weasel/bleep-that-sht`: linting, unused/dead-code detection, max-lines discipline, and deterministic repo checks.

## Interpreted Outcome

Create and run Board 5 to discover which Swift/iOS hygiene checks can be honestly enforced in GitHub-hosted CI, decide which checks should be required now versus advisory first, implement the first safe required gate, and preserve physical iPhone/TestFlight/WDA proof as separate sanitized receipt-based evidence.

## Goal Oracle

The tranche is complete when a merge-queued PR lands with one of these outcomes:

- a new required deterministic iOS hygiene gate in CI, backed by local and hosted proof; or
- a Judge receipt proving that no new gate is safe yet and a repo-native advisory/checklist artifact captures the next evidence needed.

The board must record Scout evidence, a Judge decision, Worker verification, hosted PR checks, and merge-queue proof. Local-only checks and generated summaries do not count as completion.

## Non-Goals

- Do not weaken the existing simulator-safe CI, CodeQL, or 350-line hard ratchet.
- Do not add physical iPhone, TestFlight, WDA, or preview-device lanes to GitHub-hosted CI.
- Do not introduce a formatter or linter that rewrites broad code without an explicit Worker package and proof.
- Do not accept noisy dead-code findings as required CI without a controlled baseline or false-positive analysis.
- Do not commit provider keys, App Store Connect keys, raw WDA trees, private phone content, recordings, archives, or IPAs.

## Constraints

- Prefer deterministic, repo-local scripts or pinned tools that work on GitHub-hosted macOS.
- Treat Swift/iOS target structure, generated files, XcodeGen output, and test bundles as sources of false positives until Scout/Judge prove otherwise.
- Keep the current hard max-lines cap at 350 during this tranche unless Judge explicitly approves a separate ratchet board.
- Required CI must prove only simulator-safe/static properties.
- Advisory checks are allowed only when the board records why they are not yet required.

## Likely Misfire

The most likely misfire is copying the TypeScript stack shape too literally: adding a noisy SwiftLint/Periphery-style gate that fails on generated files, preview/test targets, or intentional app-extension patterns, then claiming it is equivalent to ESLint/Knip without proving signal quality.

## Starter Command

`/goal Follow docs/goals/foil-ios-hygiene-gates-analog/goal.md.`
