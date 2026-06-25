# Foil iOS Max Lines Ratchet to 350

## Original Request

The user approved the next tranche after the 400-line hard source ratchet: start the next GoalBuddy board for the 350-line ratchet, make it Scout/Judge first, then execute the approved implementation if the evidence supports it.

## Interpreted Outcome

Prepare and run Board 4 by mapping the current blockers for a 350-line hard source cap, deciding whether the next safe ratchet should be 375 or 350, implementing the approved bounded Worker package, and landing it through the protected PR and merge queue.

## Goal Oracle

The tranche is complete when a merge-queued PR lands with `scripts/source-line-ratchet.py --json` reporting a 350-line threshold, empty allowlist, and no violations. The board must also contain the Scout/Judge receipts that justified the cap choice, the Worker receipt with local simulator-safe verification, and a final audit receipt.

## Non-Goals

- Do not edit product code during Scout or Judge.
- Do not add or use a line-count allowlist to dodge the ratchet.
- Do not weaken simulator-safe CI or overclaim physical iPhone/TestFlight/WDA proof.
- Do not start a physical device lane as part of this ratchet tranche.

## Constraints

- Preserve the existing honest CI proof boundary: GitHub-hosted CI proves simulator-safe checks, not physical insertion.
- Prefer repo-local source structure and existing test commands.
- Keep the eventual Worker slice bounded, reversible, and verified.
- Treat `state.yaml` as board truth.

## Likely Misfire

The most likely misfire is jumping straight to `MAX_LINES = 350` because the goal sounds obvious, then discovering that `ContentView.swift`, physical evidence scripts, or presenter files require a larger design split than can be safely done in one small ratchet.

## Starter Command

`/goal Follow docs/goals/foil-ios-max-lines-ratchet-350/goal.md.`
