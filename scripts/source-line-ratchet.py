#!/usr/bin/env python3
"""Audit source/script/workflow line counts and enforce the max-lines ratchet."""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path


MAX_LINES = 500
LARGEST_DEFAULT = 20

COUNT_GLOBS = (
    "FoiliOS/**/*.swift",
    "scripts/**/*.py",
    "scripts/**/*.sh",
    ".github/workflows/**/*.yml",
    ".github/workflows/**/*.yaml",
)

ALLOWLIST_BASELINES = {}


@dataclass(frozen=True)
class CountedFile:
    path: str
    lines: int


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def count_lines(path: Path) -> int:
    with path.open("rb") as handle:
        return sum(1 for _ in handle)


def counted_files(root: Path) -> list[CountedFile]:
    files: dict[str, CountedFile] = {}
    for pattern in COUNT_GLOBS:
        for path in root.glob(pattern):
            if not path.is_file():
                continue
            relative = path.relative_to(root).as_posix()
            files[relative] = CountedFile(path=relative, lines=count_lines(path))
    return sorted(files.values(), key=lambda item: (-item.lines, item.path))


def violations(files: list[CountedFile]) -> list[str]:
    return violations_for(files, MAX_LINES, ALLOWLIST_BASELINES)


def violations_for(
    files: list[CountedFile], max_lines: int, allowlist_baselines: dict[str, int]
) -> list[str]:
    failures: list[str] = []
    seen = {item.path for item in files}
    for path, baseline in allowlist_baselines.items():
        if path not in seen:
            failures.append(f"{path}: allowlisted baseline {baseline}, but file is missing")

    for item in files:
        baseline = allowlist_baselines.get(item.path)
        if baseline is not None:
            if item.lines > baseline:
                failures.append(
                    f"{item.path}: {item.lines} lines exceeds allowlisted baseline {baseline}"
                )
        elif item.lines > max_lines:
            failures.append(f"{item.path}: {item.lines} lines exceeds {max_lines}")
    return failures


def self_test() -> int:
    checks = []

    def record(name: str, passed: bool, details: list[str] | None = None) -> None:
        checks.append({"name": name, "passed": passed, "details": details or []})

    record(
        "clean-files-pass",
        violations_for(
            [
                CountedFile(path="FoiliOS/App/Clean.swift", lines=500),
                CountedFile(path="scripts/clean.py", lines=12),
            ],
            500,
            {},
        )
        == [],
    )

    over_limit = violations_for(
        [CountedFile(path="FoiliOS/App/Oversized.swift", lines=501)],
        500,
        {},
    )
    record(
        "over-limit-file-fails",
        over_limit == ["FoiliOS/App/Oversized.swift: 501 lines exceeds 500"],
        over_limit,
    )

    record(
        "allowlisted-file-at-baseline-passes",
        violations_for(
            [CountedFile(path="FoiliOS/App/Legacy.swift", lines=650)],
            500,
            {"FoiliOS/App/Legacy.swift": 650},
        )
        == [],
    )

    over_baseline = violations_for(
        [CountedFile(path="FoiliOS/App/Legacy.swift", lines=651)],
        500,
        {"FoiliOS/App/Legacy.swift": 650},
    )
    record(
        "allowlisted-file-over-baseline-fails",
        over_baseline
        == ["FoiliOS/App/Legacy.swift: 651 lines exceeds allowlisted baseline 650"],
        over_baseline,
    )

    missing_allowlist = violations_for(
        [CountedFile(path="FoiliOS/App/Other.swift", lines=10)],
        500,
        {"FoiliOS/App/Missing.swift": 650},
    )
    record(
        "missing-allowlisted-file-fails",
        missing_allowlist
        == ["FoiliOS/App/Missing.swift: allowlisted baseline 650, but file is missing"],
        missing_allowlist,
    )

    passed = all(check["passed"] for check in checks)
    print(
        json.dumps(
            {
                "schema": "foil.sourceLineRatchet.selfTest.v1",
                "passed": passed,
                "checks": checks,
            },
            indent=2,
            sort_keys=True,
        )
    )
    return 0 if passed else 1


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Enforce Foil iOS source/script/workflow max-lines ratchet."
    )
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="Run fixture-only fail-closed checks for the ratchet logic.",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Print a sanitized JSON report instead of the text report.",
    )
    parser.add_argument(
        "--largest",
        type=int,
        default=LARGEST_DEFAULT,
        help=f"Number of largest files to print. Default: {LARGEST_DEFAULT}.",
    )
    args = parser.parse_args()

    if args.self_test:
        return self_test()

    root = repo_root()
    files = counted_files(root)
    failures = violations(files)
    report = {
        "max_lines": MAX_LINES,
        "counted_globs": list(COUNT_GLOBS),
        "allowlist_baselines": ALLOWLIST_BASELINES,
        "total_files": len(files),
        "largest_files": [
            {"path": item.path, "lines": item.lines} for item in files[: args.largest]
        ],
        "violations": failures,
    }

    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(f"Max-lines threshold: {MAX_LINES}")
        print("Counted globs:")
        for pattern in COUNT_GLOBS:
            print(f"  {pattern}")
        print("Allowlisted historical baselines:")
        for path, baseline in sorted(ALLOWLIST_BASELINES.items()):
            print(f"  {baseline:5d} {path}")
        print(f"Total counted files: {len(files)}")
        print(f"Largest files (top {min(args.largest, len(files))}):")
        for item in files[: args.largest]:
            print(f"  {item.lines:5d} {item.path}")
        if failures:
            print("Violations:")
            for failure in failures:
                print(f"  {failure}")
        else:
            print("Violations: none")

    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
