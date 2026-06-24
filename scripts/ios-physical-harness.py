#!/usr/bin/env python3
"""Privacy-safe CLI wrapper for Foil iOS physical-device checks."""

from __future__ import annotations

import sys

from ios_physical_harness.cli import main


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
