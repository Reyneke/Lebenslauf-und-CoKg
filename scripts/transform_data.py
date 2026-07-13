#!/usr/bin/env python3
"""
Transform raw_data.json into data/cv.json (the normalized format consumed by the Flutter app).

Usage:
    python scripts/transform_data.py
"""

import json
from pathlib import Path

RAW_INPUT = Path("scripts/raw_data.json")
CV_OUTPUT = Path("data/cv.json")


def transform_person(raw_person: dict) -> dict:
    """Clean up personal data for the output."""
    return {
        "name": raw_person.get("name", ""),
        "photo": raw_person.get("photo", ""),
        "email": raw_person.get("email"),
        "phone": raw_person.get("phone"),
        "github": raw_person.get("github"),
        "address": raw_person.get("address"),
        "birthDate": raw_person.get("birthDate"),
    }


def transform_entry(raw_entry: dict) -> dict:
    """Clean and normalize a single CV entry."""
    cleaned = {
        "type": raw_entry.get("type", "experience"),
        "title": raw_entry.get("title", "").strip(),
        "organization": raw_entry.get("organization"),
        "startDate": raw_entry.get("startDate"),
        "endDate": raw_entry.get("endDate"),
        "description": raw_entry.get("description", "").strip(),
        "tags": raw_entry.get("tags", []),
    }

    # Remove None values for cleaner output
    cleaned = {k: v for k, v in cleaned.items() if v is not None and v != []}

    return cleaned


def transform_skill(raw_skill: dict) -> dict:
    """Clean and normalize a single skill entry."""
    return {
        "name": raw_skill.get("name", "").strip(),
        "category": raw_skill.get("category", "").strip(),
        "level": raw_skill.get("level", 3),
    }


def main():
    if not RAW_INPUT.exists():
        print(f"ERROR: {RAW_INPUT} not found. Run extract_data.py first.")
        return

    with open(RAW_INPUT, "r", encoding="utf-8") as f:
        raw_data = json.load(f)

    # Transform
    cv_data = {
        "person": transform_person(raw_data.get("person", {})),
        "entries": [transform_entry(e) for e in raw_data.get("entries", [])],
        "skills": [transform_skill(s) for s in raw_data.get("skills", [])],
    }

    # Write output
    CV_OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with open(CV_OUTPUT, "w", encoding="utf-8") as f:
        json.dump(cv_data, f, ensure_ascii=False, indent=2)

    print(f"Done. Written to {CV_OUTPUT}")
    print(f"  Entries: {len(cv_data['entries'])}")
    print(f"  Skills: {len(cv_data['skills'])}")


if __name__ == "__main__":
    main()