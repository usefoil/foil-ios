# T003 Physical Proof Blocker

Result: external_blocker

The v0.44 oracle requires physical iPhone receipts for keyboard installation,
Allow Full Access, keyboard cycling/refocus, stale state recovery, and disabled
Insert Latest states.

Current blocker:

- `scripts/ios-physical-harness.py status` reports `iPhone-preview` present and
  looking available.
- `iproxy` is present.
- The Appium WebDriverAgent project is present.
- WDA is not ready at `http://127.0.0.1:8100` and reports `URLError`.

Why this blocks completion:

Starting or restoring WDA may involve a physical-device automation install,
trust, or Settings action. The conveyor instructions require interrupting for
device unlock/install actions, so this run cannot safely create the physical
receipts unattended.

Next owner: operator

Next action: approve or perform the WDA/TestFlight/device action needed to make
physical UI automation reachable, then rerun the v0.44 physical setup and
recovery proof.
