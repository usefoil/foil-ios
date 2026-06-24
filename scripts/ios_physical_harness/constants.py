"""Shared constants for the Foil iOS physical-device harness."""

from __future__ import annotations

from pathlib import Path


DEVICE_ID = "5320F5AD-2A71-50AC-94FE-207B544B6247"
DEVICE_NAME = "iPhone-preview"
WDA_DESTINATION_ID = "00008030-001A0C980A33C02E"
TEAM_ID = "B3A6AN2HA4"
WDA_BUNDLE_ID = "com.neonwatty.WebDriverAgentRunner"
APP_GROUP_ID = "group.com.neonwatty.FoilIOS"
SNAPSHOT_PATH = "Library/foil-keyboard-snapshot.json"
WDA_URL = "http://127.0.0.1:8100"
WDA_PROJECT = Path(
    "/Users/neonwatty/.appium/node_modules/appium-xcuitest-driver/"
    "node_modules/appium-webdriveragent/WebDriverAgent.xcodeproj"
)
REPO_ROOT = Path(__file__).resolve().parents[2]
HARNESS_SCRIPT = REPO_ROOT / "scripts" / "ios-physical-harness.py"
EVIDENCE_HELPER = REPO_ROOT / "scripts" / "ios-physical-wda-evidence.py"
SWIFT_DATE_OFFSET = 978_307_200
