#!/usr/bin/env python3
"""
Extract CV data from PDF files in doc/ich/ and produce a structured raw_data.json
for further transformation into data/cv.json.

Usage:
    python scripts/extract_data.py
"""

import json
import re
from pathlib import Path

import fitz  # PyMuPDF


# ─── Configuration ─────────────────────────────────────────────────────────────
DOC_DIR = Path("doc/ich")
RAW_OUTPUT = Path("scripts/raw_data.json")

CV_PDFS = [
    "Matthias_Struck_13072026.pdf",
]


# ─── Text Extraction ───────────────────────────────────────────────────────────


def extract_text_from_pdf(pdf_path: Path) -> str:
    """Extract all text from a PDF file."""
    doc = fitz.open(str(pdf_path))
    full_text = ""
    for page in doc:
        full_text += page.get_text()
    doc.close()
    return full_text


def clean_text(raw: str) -> str:
    """Remove unicode artifacts, normalize line breaks."""
    # Replace special unicode chars with simpler equivalents
    replacements = {
        "\uf02a": "",
        "\uf020": "",
        "\uf0fc": "",
        "\uf0fe": "",
        "\uf0d8": "",
        "\uf0a7": "",
        "\uf0e7": "",
        "\uf021": "",
        "\uf0b2": "",
        "\uf0a8": "",
        "\uf0a4": "",
        "\uf0d1": "",
        "\uf0a9": "",
        "\uf0e9": "",
        "\uf0ad": "",
        "\uf0a0": "",
        "\uf0b0": "",
        "\uf0e5": "",
    }
    for k, v in replacements.items():
        raw = raw.replace(k, v)

    # Clean non-printable chars (keep newlines)
    raw = re.sub(r"[\x00-\x08\x0b\x0c\x0e-\x1f]", "", raw)

    # Split into lines, strip each, remove empties
    lines = []
    for line in raw.split("\n"):
        line = line.strip()
        if line:
            lines.append(line)

    return "\n".join(lines)


# ─── Parsing ───────────────────────────────────────────────────────────────────


def parse_sections(text: str) -> dict[str, str]:
    """Split text into named sections based on known headers."""
    sections = {}
    current_name = "__preamble__"
    current_lines = []

    # Known section headers (in order of appearance)
    headers = [
        "Persönliche Daten",
        "Beruflicher Werdegang",
        "Fort- und Weiterbildungen",
        "Werkspraktika",
        "Studium",
        "Wehrdienst",
        "Berufliche Ausbildung",
        "Schulische Ausbildung",
        "Berufliche Kenntnisse und Fertigkeiten",
        "Sonstige Fähigkeiten & Kenntnisse",
    ]

    # Build a regex that matches any header
    header_pattern = re.compile(
        "|".join(re.escape(h) for h in headers)
    )

    for line in text.split("\n"):
        if header_pattern.fullmatch(line):
            if current_lines:
                sections[current_name] = "\n".join(current_lines)
            current_name = line.strip()
            current_lines = []
        else:
            current_lines.append(line)

    if current_lines:
        sections[current_name] = "\n".join(current_lines)

    return sections


def parse_personal_data(text: str) -> dict:
    """Extract personal information from the preamble."""
    person = {
        "name": "Matthias Struck",
        "photo": "doc/ich/MatthiasStruck.jpg",
    }

    # Email
    m = re.search(r"([\w.+-]+@[\w-]+\.[\w.]+)", text)
    if m:
        person["email"] = m.group(1)

    # Phone (look for numbers with area codes like 030, 0160)
    phones = re.findall(r"(\d{3,5}\s*\d{7,})", text)
    if phones:
        person["phone"] = phones[0].strip()

    # Address line containing street and city
    m = re.search(r"([A-Za-zäöüßÄÖÜ\s.-]+\s+\d+[,\s]+\d{5}\s+[A-Za-zäöüßÄÖÜ\s-]+)", text)
    if m:
        person["address"] = m.group(1).strip()

    # Birth date
    m = re.search(r"Geburtsdatum\s+([\d.]+(?:\s*[A-Za-zäöüß]+\s*\d{4})?)", text)
    if m:
        person["birthDate"] = m.group(1).strip()

    # GitHub
    m = re.search(r"github\.com/([A-Za-z0-9_-]+)", text)
    if m:
        person["github"] = f"https://github.com/{m.group(1)}"

    return person


def parse_date_range(line: str):
    """Extract start/end date from a line. Returns (start, end) or (None, None)."""
    # "Seit DD/MM/YYYY"
    m = re.match(r"Seit\s+(\d{2}/\d{2}/\d{4})", line)
    if m:
        return (m.group(1), None)

    # "MM/YYYY – MM/YYYY" or "MM/YYYY – heute"
    m = re.match(
        r"(\d{2}/\d{4})\s*[–\-]\s*(\d{2}/\d{4}|heute|laufend|ongoing)",
        line, re.IGNORECASE
    )
    if m:
        end = m.group(2)
        if end.lower() in ("heute", "laufend", "ongoing"):
            end = None
        return (m.group(1), end)

    return (None, None)


def extract_date_from_line(line: str):
    """Remove date prefix from line and return (dates_removed, rest)."""
    rest = re.sub(
        r"^(Seit\s+\d{2}/\d{2}/\d{4})\s*",
        "", line
    ).strip()
    rest = re.sub(
        r"^(\d{2}/\d{4}\s*[–\-]\s*\d{2}/\d{4})\s*",
        "", rest
    ).strip()
    rest = re.sub(
        r"^(\d{2}/\d{4}\s*[–\-]\s*(?:heute|laufend|ongoing))\s*",
        "", rest, flags=re.IGNORECASE
    ).strip()
    return rest


def parse_entries_from_section(text: str, default_type: str) -> list[dict]:
    """Parse entries from a section (e.g. career, education).

    In the PDF, dates and titles are on separate lines:
        Seit 16/02/2026
        Tätigkeit auf Github
    """
    entries = []
    current = None
    lines = text.split("\n")
    i = 0

    while i < len(lines):
        line = lines[i].strip()
        i += 1

        # Skip page noise
        if "Matthias Struck" in line or "Seite" in line or "L E B E N S L A U F" in line:
            continue

        # Detect entry: line starts with a date range → new entry
        start, end = parse_date_range(line)
        if start:
            if current:
                entries.append(current)

            # Title may be on the same line (after date) or the next line
            title = extract_date_from_line(line)

            # If title is empty, the title is likely the next line
            if not title and i < len(lines):
                next_line = lines[i].strip()
                # Only take the next line as title if it's not a date and not a bullet
                if not parse_date_range(next_line)[0] and not next_line.startswith("✓") and not next_line.startswith(""):
                    title = next_line
                    i += 1  # consume the title line

            current = {
                "type": default_type,
                "title": title,
                "organization": None,
                "startDate": start,
                "endDate": end,
                "description": "",
                "tags": [],
            }
        elif current:
            # Check if line is a bullet point
            if line and not line[0].isalnum() and len(line) > 1 and line[1] != " ":
                desc = line.lstrip("✓-• ").strip()
            elif "✓" in line or "" in line:
                desc = line.replace("✓", "").replace("", "").strip()
            else:
                desc = None

            if desc:
                if current["description"]:
                    current["description"] += "\n" + desc
                else:
                    current["description"] = desc

    if current:
        entries.append(current)

    return entries


SKILL_LEVEL_MAP = {
    "+++": 5,
    "++": 4,
    "+": 3,
}


def parse_skills(text: str) -> list[dict]:
    """Parse skills from the skills section.

    In the PDF, skills appear as two consecutive lines:
        Skill Name
        +++
    """
    skills = []
    current_category = None
    lines = text.split("\n")
    i = 0

    while i < len(lines):
        line = lines[i].strip()
        i += 1

        if not line or "Matthias Struck" in line or "Seite" in line:
            continue

        # Detect category header
        cat_match = re.match(
            r"^(Programmiersprachen|Frameworks|Platforms\s*\(hardware\)|Betriebssysteme"
            r"|Netzwerkprotokolle\s*\([^)]+\)|Datenbanken|Programmierumgebungen"
            r"|Graphic Engines|Videoformate|Audio Formats|Hobbies|Sonstiges)$",
            line, re.IGNORECASE
        )
        if cat_match:
            current_category = cat_match.group(1).strip()
            continue

        # Only process skills within known categories
        if current_category is None:
            continue

        # Check if this line is a skill name (not a level indicator)
        # Level indicators are: +++, ++, +, or –
        if re.match(r"^(\++|–)$", line):
            continue

        # This might be a skill name – look ahead for level indicator
        skill_name = line.rstrip(",")
        # Check next lines for level
        level = 3  # default
        if i < len(lines):
            next_line = lines[i].strip()
            if re.match(r"^(\++|–)$", next_line):
                level = SKILL_LEVEL_MAP.get(next_line, 3)
                i += 1  # consume the level line
            elif re.match(r"^(\++|–)\s*$", next_line):
                level = SKILL_LEVEL_MAP.get(next_line.strip(), 3)
                i += 1

        skills.append({
            "name": skill_name,
            "category": current_category,
            "level": level,
        })

    return skills


# ─── Main ──────────────────────────────────────────────────────────────────────


def main():
    import sys

    all_text = ""
    for pdf_name in CV_PDFS:
        pdf_path = DOC_DIR / pdf_name
        if not pdf_path.exists():
            print(f"WARNING: {pdf_path} not found, skipping.", file=sys.stderr)
            continue
        raw = extract_text_from_pdf(pdf_path)
        all_text += clean_text(raw) + "\n"

    if not all_text.strip():
        print("ERROR: No text extracted.", file=sys.stderr)
        sys.exit(1)

    # Split into sections
    sections = parse_sections(all_text)

    # ─── Personal data ───────────────────────────────────────────────────────
    person_text = sections.get("__preamble__", "") + "\n" + sections.get("Persönliche Daten", "")
    person = parse_personal_data(person_text)

    # ─── Career entries ──────────────────────────────────────────────────────
    career_text = sections.get("Beruflicher Werdegang", "")
    career_entries = parse_entries_from_section(career_text, "experience")

    # ─── Education & training ────────────────────────────────────────────────
    edu_text = (
        sections.get("Fort- und Weiterbildungen", "")
    )
    edu_entries = parse_entries_from_section(edu_text, "education")

    # ─── Other sections (mapped appropriately) ───────────────────────────────
    other_map = {
        "Werkspraktika": "experience",  # internships are experience
        "Studium": "education",
        "Wehrdienst": "experience",
        "Berufliche Ausbildung": "education",
        "Schulische Ausbildung": "education",
    }

    other_entries = []
    for section_name, entry_type in other_map.items():
        section_text = sections.get(section_name, "")
        if section_text.strip():
            parsed = parse_entries_from_section(section_text, entry_type)
            other_entries.extend(parsed)

    # ─── Certificates ────────────────────────────────────────────────────────
    certificate_files = sorted(DOC_DIR.glob("*Zertifikat*"))
    certificates = []
    for cert_file in certificate_files:
        if cert_file.suffix.lower() == ".pdf":
            certificates.append({
                "type": "certificate",
                "title": cert_file.stem.replace("Matthias Struck - ", "").replace("(komprimiert)", "komprimiert"),
                "issuer": None,
                "date": None,
                "file": str(cert_file.as_posix()),
                "tags": [],
            })

    # ─── Skills ──────────────────────────────────────────────────────────────
    skills_text = sections.get("Berufliche Kenntnisse und Fertigkeiten", "")
    skills = parse_skills(skills_text)

    # ─── Combine ─────────────────────────────────────────────────────────────
    raw_data = {
        "person": person,
        "entries": career_entries + edu_entries + other_entries + certificates,
        "skills": skills,
    }

    RAW_OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with open(RAW_OUTPUT, "w", encoding="utf-8") as f:
        json.dump(raw_data, f, ensure_ascii=False, indent=2)

    print(f"Done. Written to {RAW_OUTPUT}")
    print(f"  Person: {person['name']}")
    print(f"  Career entries: {len(career_entries)}")
    print(f"  Education entries: {len(edu_entries)}")
    print(f"  Other entries: {len(other_entries)}")
    print(f"  Certificates: {len(certificates)}")
    print(f"  Skills: {len(skills)}")


if __name__ == "__main__":
    main()