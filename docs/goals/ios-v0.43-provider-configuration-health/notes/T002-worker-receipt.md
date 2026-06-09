# T002 Worker Receipt

Result: done

Implemented provider-specific recovery presentation for the iOS transcription
controller and deterministic tests for configured, missing, invalid key,
network, provider-response, transcription-quality, and recovered-success states.

Changed surface:

- `TranscriptionController` now maps provider failures into sanitized status,
  recovery, and keyboard messages.
- `FoilTranscriptionClient` and `FoilCredentialStore` expose narrow protocols so
  controller tests can use safe stubs instead of live credentials.
- `FoilProviderFailurePresentationTests` proves actionable copy and checks that
  no key, authorization header, or provider-body sentinel appears in user-facing
  failure presentation.

Verification run:

- Full simulator suite: `xcodebuild test -project FoiliOS/FoilIOS.xcodeproj -scheme FoilIOS -destination 'platform=iOS Simulator,name=iPhone 17'`
- Whitespace check: `git diff --check`
- Secret/copy scans for `gsk_`, `Authorization`, `Bearer`, and provider body
  sentinels outside intentional test fixtures.

Live provider key was not required for this slice; all provider failure states
were proven with sanitized test doubles.
