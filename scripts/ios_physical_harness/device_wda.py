"""Device, WebDriverAgent, and source-fetch commands."""

from __future__ import annotations

import re
import shutil
import sys
import urllib.error
from typing import Any

from .common import HarnessError, http_json, http_text, run_command, sanitized_process_result, sha256_text, short_hash, write_json
from .constants import DEVICE_NAME, HARNESS_SCRIPT, TEAM_ID, WDA_BUNDLE_ID, WDA_DESTINATION_ID, WDA_PROJECT


def wda_ready(wda_url: str) -> tuple[bool, dict[str, Any]]:
    try:
        payload = http_json("GET", f"{wda_url.rstrip('/')}/status", timeout=2)
    except (HarnessError, urllib.error.URLError, TimeoutError, OSError) as error:
        return False, {"error": type(error).__name__}
    return True, {
        "valueKeys": sorted(payload.get("value", {}).keys()) if isinstance(payload.get("value"), dict) else [],
        "state": payload.get("state"),
    }


def parse_device_line(output: str, device_id: str) -> dict[str, Any]:
    for line in output.splitlines():
        if device_id in line:
            parts = [part.strip() for part in re.split(r"\s{2,}", line.strip()) if part.strip()]
            state = parts[3] if len(parts) > 3 else ""
            return {
                "present": True,
                "rawLineSha256": short_hash(line),
                "state": state,
                "looksAvailable": state == "connected" or state.startswith("available"),
            }
    return {"present": False, "rawLineSha256": None, "state": None, "looksAvailable": False}


def automation_process_summary() -> dict[str, Any]:
    result = run_command(
        [
            "pgrep",
            "-af",
            "WebDriverAgent.xcodeproj.*WebDriverAgentRunner-nodebug|xcodebuild.*WebDriverAgent|iproxy.*8100",
        ],
        timeout=10,
    )
    lines = [line for line in result.stdout.splitlines() if line.strip()] if result.returncode == 0 else []
    return {
        "returncode": result.returncode,
        "count": len(lines),
        "lineHashes": [short_hash(line) for line in lines],
        "printedCommandLines": False,
    }


def classify_preflight(
    device_summary: dict[str, Any],
    iproxy_present: bool,
    wda_project_present: bool,
    wda_ready_state: bool,
    self_test_passed: bool,
) -> tuple[str, str]:
    if not device_summary.get("present") or not device_summary.get("looksAvailable"):
        return "device_unavailable", "Unlock/connect iPhone-preview and confirm Xcode device preparation is healthy."
    if not iproxy_present or not wda_project_present:
        return "tooling_missing", "Install/repair iproxy or the Appium WebDriverAgent project before physical testing."
    if not self_test_passed:
        return "redaction_self_test_failed", "Fix the sanitized evidence helper before collecting physical receipts."
    if not wda_ready_state:
        return "wda_unreachable", "Start or repair WDA, then rerun preflight before touching host apps."
    return "healthy", "Proceed only with sterile host-app fixtures and sanitized receipts."


def cmd_preflight(args) -> int:
    devicectl = run_command(["xcrun", "devicectl", "list", "devices"], timeout=20)
    device_summary = (
        parse_device_line(devicectl.stdout, args.device_id)
        if devicectl.returncode == 0
        else {"present": False, "rawLineSha256": None, "looksAvailable": False}
    )
    ready, wda_payload = wda_ready(args.wda_url)
    self_test = run_command([sys.executable, str(HARNESS_SCRIPT), "self-test"], timeout=30)
    self_test_passed = self_test.returncode == 0
    iproxy_path = shutil.which("iproxy")
    classification, next_action = classify_preflight(
        device_summary=device_summary,
        iproxy_present=iproxy_path is not None,
        wda_project_present=WDA_PROJECT.exists(),
        wda_ready_state=ready,
        self_test_passed=self_test_passed,
    )
    receipt = {
        "schema": "foil.iosPhysicalHarness.preflight.v1",
        "classification": classification,
        "safeToTouchHostApps": classification == "healthy",
        "nextAction": next_action,
        "device": {
            "name": DEVICE_NAME,
            "identifier": args.device_id,
            "devicectlReturncode": devicectl.returncode,
            "summary": device_summary,
        },
        "tooling": {
            "iproxyPresent": iproxy_path is not None,
            "iproxyPath": iproxy_path,
            "wdaProjectPresent": WDA_PROJECT.exists(),
            "wdaCommandAvailable": True,
        },
        "wda": {"url": args.wda_url, "ready": ready, "status": wda_payload},
        "redaction": {"selfTestPassed": self_test_passed, "selfTest": sanitized_process_result(self_test)},
        "automationProcesses": automation_process_summary(),
        "privacy": {
            "openedHostApps": False,
            "printedRawWdaSource": False,
            "printedScreenshots": False,
            "printedTranscriptBodies": False,
        },
    }
    write_json(receipt)
    if args.strict and classification != "healthy":
        return 1
    return 0


def wda_command_lines() -> list[str]:
    return [
        "xcodebuild \\",
        f"  -project {WDA_PROJECT} \\",
        "  -scheme WebDriverAgentRunner-nodebug \\",
        f"  -destination 'id={WDA_DESTINATION_ID}' \\",
        "  -configuration Debug \\",
        f"  DEVELOPMENT_TEAM={TEAM_ID} \\",
        "  CODE_SIGN_STYLE=Automatic \\",
        f"  PRODUCT_BUNDLE_IDENTIFIER={WDA_BUNDLE_ID} \\",
        "  -allowProvisioningUpdates \\",
        "  test 2>&1 | tee /tmp/foil-ios-wda.log",
    ]


def cmd_status(args) -> int:
    devicectl = run_command(["xcrun", "devicectl", "list", "devices"], timeout=20)
    ready, wda_payload = wda_ready(args.wda_url)
    payload = {
        "schema": "foil.iosPhysicalHarness.status.v1",
        "device": {
            "name": DEVICE_NAME,
            "identifier": args.device_id,
            "devicectlReturncode": devicectl.returncode,
            "summary": parse_device_line(devicectl.stdout, args.device_id) if devicectl.returncode == 0 else {"present": False},
        },
        "wda": {"url": args.wda_url, "ready": ready, "status": wda_payload, "projectPresent": WDA_PROJECT.exists()},
        "iproxy": {"path": shutil.which("iproxy"), "present": shutil.which("iproxy") is not None},
    }
    write_json(payload)
    return 0


def cmd_wda_command(_) -> int:
    print("\n".join(wda_command_lines()))
    return 0


def cmd_session(args) -> int:
    payload = {"capabilities": {"alwaysMatch": {"platformName": "iOS", "automationName": "XCUITest"}}}
    response = http_json("POST", f"{args.wda_url.rstrip('/')}/session", payload=payload, timeout=10)
    value = response.get("value")
    session_id = None
    if isinstance(value, dict):
        session_id = value.get("sessionId") or response.get("sessionId")
    elif isinstance(response.get("sessionId"), str):
        session_id = response.get("sessionId")
    if not session_id:
        raise HarnessError("WDA session response did not include a session id")
    write_json({"schema": "foil.iosPhysicalHarness.session.v1", "sessionId": session_id, "wdaUrl": args.wda_url, "bundleIdProvided": False})
    return 0


def cmd_delete_session(args) -> int:
    try:
        response = http_json("DELETE", f"{args.wda_url.rstrip('/')}/session/{args.session_id}", timeout=10)
        deleted = True
    except (HarnessError, urllib.error.URLError, TimeoutError, OSError) as error:
        response = {"error": type(error).__name__}
        deleted = False
    write_json({"schema": "foil.iosPhysicalHarness.deleteSession.v1", "sessionId": args.session_id, "deleted": deleted, "response": response})
    return 0 if deleted else 1


def cmd_fetch_source(args) -> int:
    raw = http_text("GET", f"{args.wda_url.rstrip('/')}/session/{args.session_id}/source", timeout=15)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(raw, encoding="utf-8")
    write_json(
        {
            "schema": "foil.iosPhysicalHarness.fetchSource.v1",
            "sessionId": args.session_id,
            "output": str(args.output),
            "sha256": sha256_text(raw),
            "bytes": len(raw.encode("utf-8")),
            "printedRawSource": False,
        }
    )
    return 0
