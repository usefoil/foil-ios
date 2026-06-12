# T003 Physical Blocker - Insert Latest Usage UX

Date: 2026-06-09

## Blocker

Physical host-field proof is blocked because WDA is not reachable.

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

## Blocked oracle

The following v0.46 acceptance criteria remain unproven on physical iPhone:

- exactly-once insertion into a sterile host field;
- disabled-after-insert behavior on the real keyboard;
- stale transcript refusal in the keyboard extension;
- App Group idle/no-transcript state after physical insertion or cleanup.

## Next owner/action

Operator: approve or perform the WDA/TestFlight/device actions required to make
physical UI automation reachable, then rerun v0.46 host-field proof with a
sterile text field and sanitized receipts.
