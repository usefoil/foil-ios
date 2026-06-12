# T004 Final TestFlight Rehearsal Audit

Decision: blocked_before_upload

Strongest realistic failure mode: we could accidentally claim a closed-beta
candidate was uploaded, available in TestFlight, installed, or smoked when only
a local IPA was produced.

Evidence ruling that down:

- The v0.52 receipts explicitly separate local archive/export success from
  App Store Connect upload.
- `altool --validate-app` without credentials failed with an authentication
  requirement; no upload command was run.
- No TestFlight install/update was run because there is no uploaded build 13
  and physical WDA preflight was not healthy.
- README wording says `0.1.0 (13)` is the current source version while the
  released TestFlight claim remains build `0.1.0 (12)`.

What is true:

- Build `0.1.0 (13)` source metadata is prepared.
- The build-13 IPA archives/exports locally and has correct app/keyboard
  version metadata and required app icon contents.

What is not true yet:

- Build `0.1.0 (13)` is not verified as uploaded, processed, export-compliance
  cleared, attached to the internal group, installed on preview iPhone, or
  physically smoked.
