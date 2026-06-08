# T002 Recovery Judge

## Decision

`approve_non_destructive_wda_recovery`

## Rationale

T001 shows WDA reaches the XCTest runner and fails at automation-mode
enablement. Product-code work would be premature because no Foil app path is in
the failing stack.

## Approved Worker Route

Run one bounded local recovery pass:

1. Verify no stale WDA, `xcodebuild`, or `iproxy` process is serving/holding
   port 8100.
2. Verify the device is paired/available after the failed attempt.
3. Inspect installed WDA runner state without uninstalling user apps or touching
   private host apps.
4. Try a fresh WDA start once more after stale-process cleanup.
5. If WDA becomes ready, create/delete a session and fetch only sanitized source
   metadata from a sterile surface.
6. If the same automation-mode timeout repeats, stop and classify the next
   action as operator-side device/Xcode automation setup.

## Stop Conditions

- The phone locks, disconnects, or displays a trust, Developer Mode,
  automation, install, or credentials prompt.
- Any step would erase data, reset the phone, uninstall user apps, or inspect
  private host-app content.
- Raw WDA source, screenshots, private phone content, transcripts, provider
  keys, or account data would need to be committed.
- The same XCTest automation-mode timeout repeats after the fresh cleanup pass.
