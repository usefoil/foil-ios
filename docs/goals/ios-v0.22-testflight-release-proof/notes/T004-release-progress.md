# T004 Release Progress: Upload And TestFlight Attachment

## Claim

Foil iOS build `0.1.0 (11)` was validated, uploaded, export-compliance-cleared,
and attached to the `Foil Internal Testers` TestFlight group. Physical
install/update and live smoke are blocked on the phone being locked.

## Strongest Realistic Failure Mode

The release could appear uploaded but not actually be available to internal
TestFlight testers because export compliance or beta-group attachment drifted.

## Evidence

- `altool --validate-app` reported `VERIFY SUCCEEDED with no errors`.
- `altool --upload-app` reported `UPLOAD SUCCEEDED with no errors`.
- Delivery/build ID: `12ba179e-cc4d-4685-920f-ccc3bc916fa9`.
- `altool --build-status` reported:
  - `build-status: VALID`
  - `import-status: VALID`
  - `is-on-app-store-connect: true`
  - `uses-non-exempt-encryption: false`
- App Store Connect REST initially found build `11` with
  `internalBuildState: MISSING_EXPORT_COMPLIANCE`.
- App Store Connect REST `PATCH /v1/builds/...` set
  `usesNonExemptEncryption=false`.
- Follow-up build detail showed:
  - version `11`
  - `processingState: VALID`
  - `expired: false`
  - `usesNonExemptEncryption: false`
  - `internalBuildState: READY_FOR_BETA_TESTING`
  - `externalBuildState: READY_FOR_BETA_SUBMISSION`
- App Store Connect REST attached the build to `Foil Internal Testers` with HTTP
  `204`.
- Group verification showed `contains_build11=true`; builds `1` through `11`
  are listed as valid, not expired, and encryption-cleared.

## Current Blocker

Device-side proof cannot continue until `iPhone-preview` is unlocked. The phone
is visible and paired, but `devicectl device info apps` failed because the
developer disk image cannot mount while the device is locked:

- CoreDevice error: developer disk image could not be mounted.
- MobileDevice error: `kAMDMobileImageMounterDeviceLocked`.
- WDA is not listening at `http://127.0.0.1:8100/status`.

## Residual Risk / Follow-Up

The remaining release proof must install or update build `11` through TestFlight
on `iPhone-preview`, confirm installed app metadata reports build `11`, then run
the physical live transcription and exact-once keyboard insertion smoke.
