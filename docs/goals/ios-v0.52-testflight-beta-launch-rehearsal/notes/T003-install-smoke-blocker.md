# T003 Install And Smoke Blocker

Result: blocked

The candidate IPA exists locally, but TestFlight install/update and post-update
physical smoke are blocked.

Blockers:

- Build `0.1.0 (13)` has not been uploaded to App Store Connect/TestFlight.
- The upload is blocked on App Store Connect authentication command inputs.
- `iPhone-preview` was not safe for host-app automation during preflight because
  WDA was unreachable.

No TestFlight install/update, host-app launch, keyboard interaction, screenshot,
or private phone surface was touched for this task.

Next operator actions:

- Provide App Store Connect API key ID plus issuer ID, or Apple ID app-password
  and provider public ID, through a safe channel.
- Make `iPhone-preview` available/unlocked and restore WDA/physical automation
  before the post-update smoke.
