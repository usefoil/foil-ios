# T001 Physical Preflight

## Decision

`blocked_by_locked_preview_iphone`

## What Is Ready

CoreDevice can see `iPhone-preview`:

- device identifier: `5320F5AD-2A71-50AC-94FE-207B544B6247`
- hardware UDID: `00008030-001A0C980A33C02E`
- boot state: `booted`
- developer mode: `enabled`
- pairing state: `paired`
- transport: `localNetwork`
- tunnel state: `connected`
- iOS version: `26.5`

Build 12 release proof is complete:

- App Store Connect delivery/build ID:
  `75f05a85-cfe5-443f-bc9a-32ff8c27b710`
- build status: `VALID`
- beta detail: `IN_BETA_TESTING`
- `Foil Internal Testers` contains build `12`

Installed device state before physical smoke:

- `devicectl device info apps` reports Foil iOS `0.1.0` bundle version `11`.
- Physical smoke cannot start until the preview phone installs/updates to build
  `12`.

## Blocker

WDA is not reachable at `http://192.168.1.40:8100`.

Restarting WDA with the runbook command built/signed far enough to hit Xcode's
run-destination preflight, then stopped with:

```text
Unlock iPhone-preview to Continue
Xcode cannot launch WebDriverAgentRunner on iPhone-preview because the device is locked.
```

The same blocker reproduced across consecutive goal continuations. WDA runner
processes from the attempts were stopped after the blocker was confirmed.

## Exact Next Action

Owner: operator/user.

Action:

1. Unlock `iPhone-preview`.
2. Leave it awake.
3. Confirm TestFlight/build update prompts on device if they appear.
4. Tell Codex `done`.

After that, Codex should restart WDA, confirm `/status`, install/update Foil iOS
to build `12`, and resume the v0.37 physical onboarding smoke.
