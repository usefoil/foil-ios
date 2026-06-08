# Foil iOS v0.27 Notes Row Proof

## Original Request

Run the Notes row after the operator opened a fresh blank note with Foil Keyboard
visible.

## Outcome

Prove Foil Keyboard inserts a staged sterile transcript into a fresh Notes
editor exactly once on physical `iPhone-preview`, then clears shared App Group
state.

## Oracle

This board is complete when sanitized WDA/App Group receipts prove:

- WDA is ready through the direct device URL.
- The active surface is a sterile Notes editor with Foil Keyboard visible.
- Insert latest is enabled before insertion.
- The sterile value appears exactly once after insertion.
- Insert latest becomes disabled and App Group returns to idle/no transcript.

## Non-Goals

- Do not inspect private notes, notes lists, screenshots, contacts, provider
  keys, transcript bodies, or raw WDA source.
- Do not claim Messages or Mail rows.

## Starter Command

`/goal Follow docs/goals/ios-v0.27-notes-row-proof/goal.md.`
