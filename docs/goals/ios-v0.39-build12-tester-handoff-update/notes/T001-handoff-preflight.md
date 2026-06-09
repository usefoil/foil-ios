# T001 Handoff Preflight

## Decision

`ready_for_build12_copy_update`

## Proof Gates

Build 12 can be named in tester-facing copy because:

- v0.36 proves App Store Connect/TestFlight build `0.1.0 (12)` is uploaded,
  valid, export-compliance safe, and attached to `Foil Internal Testers`.
- v0.37 proves `iPhone-preview` installed build `12` and the physical
  onboarding/setup guidance rendered on device.
- v0.38 reran host-app rows on build `12` with sanitized physical receipts.

## Copy Changes Needed

Update:

- `docs/ios-closed-beta-tester-handoff.md`
  - current beta target from `0.1.0 (11)` to `0.1.0 (12)`
  - safe claim from build `11` to build `12`
  - proven section to distinguish build 12 proof from earlier historical rows
  - task guidance so Notes/Messages are safe optional targets, not guaranteed
    build 12 pass rows
- `README.md`
  - current source version from `0.1.0 (11)` to `0.1.0 (12)`
  - claim boundary to mention build 12 Safari proof and build 12
    Notes/Messages blockers

## Risks To Preserve

Do not claim:

- broad iPhone app compatibility
- public App Store availability
- Mail support
- Messages delivery
- existing private-thread support
- build 12 Notes pass
- build 12 Messages pass
- arbitrary third-party app support

Keep:

- Full Access required
- keyboard cycling/refocus friction
- secure fields reject custom keyboards
- private screenshots/content should not be sent
- Mail deferred under issue #12
