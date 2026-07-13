"""
Download Google Fonts (Poppins, Lato) as WOFF2 files for local hosting.
Lato only has weights: 100, 300, 400, 700, 900 (no 500 or 600).
We map: 500->700, 600->700 for Lato; keep as-is for Poppins.
"""
import requests
import os
import re

FONTS_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'assets', 'fonts')
os.makedirs(FONTS_DIR, exist_ok=True)

# Lato doesn't have 500 or 600 weights, so we map them to 700 (bold)
FONT_SPECS = {
    'Poppins': [400, 500, 600],
    'Lato': [400, 700],  # 500/600 not available, use 700 instead
}


def download_font(family, weight):
    """Download a single font variant from Google Fonts CSS API."""
    css_url = (
        f"https://fonts.googleapis.com/css2?"
        f"family={family.replace(' ', '+')}:wght@{weight}"
        f"&display=swap"
    )

    headers = {
        'User-Agent': (
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
            'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        ),
    }

    resp = requests.get(css_url, headers=headers, timeout=30)
    if resp.status_code != 200:
        print(f"  CSS fetch failed for {family} w{weight}: HTTP {resp.status_code}")
        return None

    # Extract the font URL from @font-face CSS
    urls = re.findall(r"url\((https://fonts\.gstatic\.com/[^)]+)\)", resp.text)
    if not urls:
        print(f"  No font URL found for {family} w{weight}")
        return None

    font_url = urls[0]
    filename = os.path.basename(font_url.split('?')[0])
    if not filename.endswith(('.woff2', '.ttf')):
        filename = f"{family.lower()}_{weight}.woff2"

    target = os.path.join(FONTS_DIR, filename)
    print(f"  Downloading {family} w{weight} -> {filename}...")

    font_resp = requests.get(font_url, timeout=30)
    if font_resp.status_code != 200:
        print(f"    Failed: HTTP {font_resp.status_code}")
        return None

    with open(target, 'wb') as f:
        f.write(font_resp.content)

    size_kb = len(font_resp.content) / 1024
    print(f"    Saved: {filename} ({size_kb:.1f} KB)")
    return filename


def rename_file(src_path, new_name):
    """Rename file, skipping if target already exists."""
    dst = os.path.join(os.path.dirname(src_path), new_name)
    if os.path.exists(dst):
        return
    os.rename(src_path, dst)


def main():
    print(f"Downloading fonts to: {FONTS_DIR}")
    total = 0
    for family, weights in FONT_SPECS.items():
        print(f"\n{family}:")
        for weight in weights:
            result = download_font(family, weight)
            if result:
                total += 1

    # Rename files to human-readable names
    print("\nRenaming to readable filenames...")
    name_map = {
        'pxiEyp8kv8JHgFVrJJbecmNE.woff2': 'Poppins-Regular.woff2',
        'pxiByp8kv8JHgFVrLGT9Z11lFc-K.woff2': 'Poppins-Medium.woff2',
        'pxiByp8kv8JHgFVrLEj6Z11lFc-K.woff2': 'Poppins-SemiBold.woff2',
        'S6uyw4BMUTPHjxAwXjeu.woff2': 'Lato-Regular.woff2',
        'S6u9w4BMUTPHh6UVSwiPGQ3q5d0.woff2': 'Lato-Bold.woff2',
        'S6u_w4BMUTPHjxsI5wq_Gwftx9897g.woff2': 'Lato-Bold.woff2',
    }
    for old_name, new_name in name_map.items():
        old_path = os.path.join(FONTS_DIR, old_name)
        if os.path.exists(old_path):
            rename_file(old_path, new_name)
            print(f"  {old_name} -> {new_name}")

    print(f"\nDownloaded {total} font files.")
    print("\nFinal font files in assets/fonts/:")
    for f in sorted(os.listdir(FONTS_DIR)):
        size_kb = os.path.getsize(os.path.join(FONTS_DIR, f)) / 1024
        print(f"  {f} ({size_kb:.1f} KB)")

    print("\nDone. Now update pubspec.yaml and app_theme.dart to use local fonts.")


if __name__ == '__main__':
    main()