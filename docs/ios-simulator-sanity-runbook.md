# Foil iOS Simulator Sanity Runbook

Use this lane before slower physical iPhone boards and before release
rehearsal. It is intentionally simulator-only.

```bash
scripts/ios-simulator-sanity.sh
```

The lane runs:

- `xcodebuild -list` for project/scheme visibility;
- the full `FoilIOS` simulator test suite on `iPhone 17` by default;
- unsigned generic iOS compile to ensure the app and keyboard extension build
  for device SDK without requiring signing.

Override the simulator destination when needed:

```bash
IOS_SIMULATOR_DESTINATION='platform=iOS Simulator,name=iPhone 16' \
  scripts/ios-simulator-sanity.sh
```

## Proof Boundary

Passing this lane means the app, keyboard extension, shared bridge, provider
presentation, transcript quality checks, and keyboard-state fixtures compiled
and passed deterministic simulator tests.

It does not prove:

- physical iPhone install/update;
- custom keyboard availability in a host app;
- Settings or Allow Full Access behavior;
- microphone permission on the preview phone;
- host-app insertion into Safari, Notes, Messages, Reminders, Mail, or secure
  fields.

Use `scripts/ios-physical-harness.py preflight --strict` and the physical
host-app matrix receipts for those claims.
