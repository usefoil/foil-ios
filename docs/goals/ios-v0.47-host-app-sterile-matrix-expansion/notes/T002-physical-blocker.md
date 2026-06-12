# T002 Physical Blocker - Host-App Sterile Matrix Expansion

Date: 2026-06-09

## Blocker

The v0.47 host-app matrix cannot run because WDA is not reachable.

## Evidence

`scripts/ios-physical-harness.py status` returned:

```json
{
  "device": {
    "name": "iPhone-preview",
    "summary": {
      "looksAvailable": true,
      "present": true
    }
  },
  "iproxy": {
    "present": true
  },
  "wda": {
    "projectPresent": true,
    "ready": false,
    "status": {
      "error": "URLError"
    },
    "url": "http://127.0.0.1:8100"
  }
}
```

## Current classification

- Safari normal: blocked, not rerun.
- Safari secure/password: blocked, not rerun.
- Notes blank editor: privacy blocked until a sterile editor can be prechecked.
- Messages fake or dedicated draft: privacy blocked until a sterile compose or
  draft surface can be prechecked.
- Reminders or other safe Apple text surface: blocked, not rerun.
- Mail blank compose: deferred by issue #12.

## Next owner/action

Operator: restore WDA or another privacy-safe physical automation path. Then
rerun the matrix one row at a time, stopping before any private host-app
surface, raw WDA source, screenshot, message, email, account detail, or
transcript body would be committed.
