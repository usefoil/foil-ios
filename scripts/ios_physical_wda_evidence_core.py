"""Pure helpers for sanitized iOS WDA evidence receipts."""

from __future__ import annotations

import hashlib
import json
import xml.etree.ElementTree as ET
from pathlib import Path


def sha256_text(value: str) -> str:
    return hashlib.sha256(value.encode("utf-8")).hexdigest()


def short_hash(value: str) -> str:
    return sha256_text(value)[:16]


def load_wda_source(path: Path) -> str:
    raw = path.read_text(encoding="utf-8")
    try:
        payload = json.loads(raw)
    except json.JSONDecodeError:
        return raw

    value = payload.get("value") if isinstance(payload, dict) else None
    if isinstance(value, str):
        return value
    raise ValueError(f"{path} does not look like WDA source JSON or raw XML")


def xml_nodes(source: str) -> list[dict[str, str]]:
    try:
        root = ET.fromstring(source)
    except ET.ParseError as error:
        raise ValueError(f"WDA source XML could not be parsed: {error}") from error

    return [dict(element.attrib) for element in root.iter()]


def has_identifier(nodes: list[dict[str, str]], identifier: str) -> bool:
    return any(node.get("name") == identifier for node in nodes)


def identifier_attribute_matches(
    nodes: list[dict[str, str]],
    identifier: str,
    attribute: str,
    expected: str,
) -> tuple[bool, list[str]]:
    values = [node.get(attribute, "") for node in nodes if node.get("name") == identifier]
    return any(value == expected for value in values), values


def value_count(nodes: list[dict[str, str]], text: str) -> int:
    needle = text.casefold()
    return sum(node.get("value", "").casefold().count(needle) for node in nodes)


def value_contains(nodes: list[dict[str, str]], text: str) -> bool:
    return value_count(nodes, text) > 0


def accessible_text_contains(nodes: list[dict[str, str]], text: str) -> bool:
    needle = text.casefold()
    return any(
        needle in node.get(attribute, "").casefold()
        for node in nodes
        for attribute in ("name", "label", "value")
    )
