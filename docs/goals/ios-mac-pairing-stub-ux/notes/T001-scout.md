# T001 Scout: Mac Pairing Stub UX Context

## Current State

- `AGENTS.md` requires burden-of-proof evidence and sanitized receipts for
  release, provider, keyboard insertion, and physical-device work.
- Issue #39 is closed. Its scope was route-first onboarding around **Use my
  Mac**, **Use an API key on this iPhone**, and Advanced/demo/support paths,
  while preserving exact-once insertion and stale-state recovery.
- The build-13 release gate is done. Its final audit proves the TestFlight
  install/replace/open path, stale keyboard health blocking, keyboard health
  recovery, final `onboarding-ready`, and App Group idle/no transcript.
- Shared contract PR `usefoil/foil#298` is merged and defines V1 names:
  `foil.localBridge`, `RouteReceipt`, iOS route label **Use my Mac**, fallback
  label **Use an API key on this iPhone**, default request route
  `mac-selected`, route IDs `local-whisper-cpp`, `openai-whisper`,
  `custom-openai-compatible`, and request-only `mac-default`.

## Code Map

- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
  - route choice order is already Mac, API key, Advanced.
  - Mac route is `use-my-mac`, recommended, and not usable now.
  - API-key route is `iphone-api-key` and usable now.
  - `onboardingReadinessPresentation(selectedRouteID: macRouteID, ...)`
    always returns `isComplete=false`.
  - Advanced route also returns `isComplete=false`.
  - API-key route still gates on provider key, microphone, keyboard health,
    Full Access, snapshot phase/transcript, and storage write health.
- `FoiliOS/FoilIOSApp/ContentView.swift`
  - Mac route details show a preview and a button back to API-key setup.
  - Advanced / Support disclosure contains diagnostics and fake transcript
    controls.
  - readiness panel exposes `onboarding-ready` only when presenter says complete.
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
  - already tests Mac first/API-key usable ordering.
  - already tests Full Access and keyboard health copy.
  - already tests Mac stub never completes readiness.
  - already tests API-key readiness completes only for healthy inputs.

## Gap

The product behavior is mostly present, but the Mac pairing preview is
copy-driven. There is no stable, testable presentation/model seam carrying the
shared-contract names from PR #298 (`foil.localBridge`, `mac-selected`,
`RouteReceipt`, and supported route IDs). Adding that seam is the smallest
aligned slice: it makes the future bridge contract visible to tests without
claiming a working bridge or changing the readiness gate.

## Recommended Next Step

Add a deterministic `FoilMacPairingPreviewPresentation` (or equivalent) to the
presenter layer and use it in the Mac route details. Tests should prove:

- protocol family is `foil.localBridge`;
- request route ID is `mac-selected`;
- route receipt name is `RouteReceipt`;
- supported future route IDs include `local-whisper-cpp`, `openai-whisper`,
  and `custom-openai-compatible`;
- the Mac stub remains not usable now and cannot complete onboarding;
- API-key route still completes when all existing readiness gates are healthy.
