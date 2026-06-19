# T001 Worker Receipt

Result: done.

Implemented the first UX polish slice:

- The default beta route is now the iPhone API-key route via `defaultBetaRouteID`.
- The Mac route remains visible and future-facing, but no longer reads like the route a current beta tester should complete today.
- The iPhone API-key route is explicitly labeled as the current beta path.
- Full Access copy now prepares testers for Apple's broad warning while keeping Foil's use narrow: read and clear Foil shared transcript state only.
- Ready/recording handoff copy now names the human loop: return to the target field, switch to Foil Keyboard, and tap Insert latest once.
- Tested target guidance is visible in setup/recovery surfaces, not only inside Advanced / Support.

Changed files:

- `FoiliOS/FoilIOSApp/ContentView.swift`
- `FoiliOS/Shared/FoilDictationLoopPresenter.swift`
- `FoiliOS/FoilIOSTests/FoilDictationLoopPresentationTests.swift`
- `docs/goals/ios-beta-ux-buttery-polish/**`

Verification:

- `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:FoilIOSTests/FoilDictationLoopPresentationTests`: pass, 31 tests.
- `git diff --check`: pass.
- `node /Users/neonwatty/.codex/plugins/cache/goalbuddy/goalbuddy/0.3.8/skills/goalbuddy/scripts/check-goal-state.mjs docs/goals/ios-beta-ux-buttery-polish/state.yaml`: pass before receipt update.
- No-overclaim scan over changed product/test files found only guarded negative claims such as Mac route not connected and no broad iPhone app support.

Burden of proof:

- The change does not loosen setup-complete gates, insertion gates, App Group state, provider state, or secure-field behavior. It only changes route defaults, visible guidance, and tests around those presentation claims.
- The strongest realistic failure mode for this slice is accidentally making the Mac route look usable now or hiding the current API-key path. Focused tests now assert the default beta route is `iphone-api-key`, Mac remains unusable/future-facing, and the iPhone route is labeled as the current beta path.
