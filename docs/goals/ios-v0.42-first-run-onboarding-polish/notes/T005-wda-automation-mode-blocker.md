# T005 WDA Automation Mode Blocker

Superseded: this WDA blocker was later resolved. T006 used a healthy direct WDA
URL to collect final onboarding-ready physical receipts, and PR #27 merged on
2026-06-19.

Claim: PR #27 cannot collect the final onboarding-ready physical receipt until WebDriverAgent can enable UI automation mode on iPhone-preview.

Strongest realistic failure mode: the conveyor proceeds to touch host apps or claims setup-ready proof while WDA is unreachable after a failed XCTest runner launch.

Evidence:
- `notes/physical/T005-wda-automation-mode-summary.json` records three WDA launch attempts, including the latest unlocked retry at `2026-06-18T22:20:30Z`.
- The latest WDA attempt launched `WebDriverAgentRunner-Runner` on iPhone-preview but failed with `Timed out while enabling automation mode`.
- The strict preflight after the retry classified the device as `wda_unreachable`, reported iPhone-preview as available/paired, reported zero automation processes, and returned `safeToTouchHostApps: false`.
- WDA raw logs and the `.xcresult` bundle were not committed because they can contain private device diagnostics. The receipt stores only byte counts, hashes, booleans, and the sanitized failure classification.

Current blocker: iPhone-preview is visible and paired, but XCTest cannot enable UI automation mode, so the harness cannot safely inspect Foil, verify keyboard health / Full Access, reset App Group state from UI, or collect onboarding-ready proof.

Next operator action: keep iPhone-preview awake and unlocked, then approve any Trust / Developer Mode / UI Automation / WebDriverAgent prompt that appears during WDA launch. If no prompt appears, reconnect or re-pair the device, reboot the phone, or use a direct USB path before rerunning strict preflight.

Residual risk / follow-up: the previously collected T004 receipts still prove the onboarding UI does not overclaim ready while gates are unmet, but they do not prove the final setup-complete state after microphone, keyboard, provider route, App Group, and insertion gates pass.
