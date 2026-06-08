# Foil iOS v0.28 Messages Row Attempt

## Original Request

Run the Messages host-app row after the operator reported a sterile thread was
ready.

## Outcome

Do not insert into Messages unless the visible thread is sterile. This attempt
is a privacy blocker, not a pass.

## Oracle

This board is complete when the Messages row either passes in a truly sterile
self/test thread or is blocked before insertion with cleanup proof.

## Non-Goals

- Do not inspect private Messages content, contacts, phone numbers, thread
  lists, screenshots, or raw WDA source.
- Do not tap Insert latest if the visible thread is not sterile.

## Starter Command

`/goal Follow docs/goals/ios-v0.28-messages-row-proof/goal.md.`
