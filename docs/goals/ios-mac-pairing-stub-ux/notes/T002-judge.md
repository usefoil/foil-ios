# T002 Judge: Approved Mac Pairing Stub Behavior

Verdict: approved.

## Approved Slice

Implement a small presenter-level Mac pairing preview model that names the V1
local pairing bridge contract without creating a real bridge:

- protocol family: `foil.localBridge`;
- default requested route ID: `mac-selected`;
- receipt object: `RouteReceipt`;
- future route IDs: `local-whisper-cpp`, `openai-whisper`,
  `custom-openai-compatible`;
- user copy: Mac pairing is not connected in this build, use the iPhone API-key
  route to complete setup today, and receipts appear only after a Mac handles a
  request.

## Required Tests

- Mac preview exposes the shared-contract names above.
- Mac route remains recommended but `isUsableNow == false`.
- Mac route cannot make onboarding complete, even when all other gates are
  healthy.
- API-key route can still make onboarding complete when provider key,
  microphone, Full Access, keyboard health, snapshot state, and App Group
  storage health are all healthy.

## Rejected Work

- No network discovery, Bonjour, credential offer, encryption, or real pairing.
- No provider-key handoff from iPhone to Mac.
- No route receipt claiming a Mac handled audio.
- No weakening of Advanced / Support containment.
