"""
Concatenate images in Raw/ into a multi-page PDF.

Naming (required):
  <page>[.<order>].<ext>
  e.g. 7.jpg  |  7.1.jpg  |  7.2.jpg  |  12.3.png

  - <page>  : integer → which PDF page
  - <order> : optional integer → top→bottom order on that page
              (missing order sorts before any explicit order)
  - anything else → error

Layout:
  - Page width fixed at 800px; each image scaled to full width
  - Pages ordered by <page>; on each page top→bottom, no gaps
  - Output: result.pdf (overwrite)
"""

from __future__ import annotations

import re
import sys
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path

from PIL import Image

RAW_DIR = Path(__file__).resolve().parent / "Raw"
OUT_PDF = Path(__file__).resolve().parent / "result.pdf"

PAGE_WIDTH = 800
EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".tif", ".tiff", ".bmp", ".gif"}

# stem only: "7" or "7.1" (extension checked separately)
NAME_RE = re.compile(r"^(\d+)(?:\.(\d+))?$")


@dataclass(frozen=True, order=True)
class Photo:
    page: int
    order: int  # -1 when optional order omitted → sorts first
    path: Path


def parse_photo(path: Path) -> Photo:
    if path.suffix.lower() not in EXTENSIONS:
        raise ValueError(f"unsupported extension: {path.name}")
    m = NAME_RE.fullmatch(path.stem)
    if not m:
        raise ValueError(
            f"bad name {path.name!r}; expected <num>[.<num>].<ext> "
            f"(e.g. 7.jpg, 7.1.jpg)"
        )
    page = int(m.group(1))
    order = int(m.group(2)) if m.group(2) is not None else -1
    return Photo(page=page, order=order, path=path)


def list_photos(raw_dir: Path) -> list[Photo]:
    if not raw_dir.is_dir():
        raise SystemExit(f"Raw directory not found: {raw_dir}")

    files = [
        p
        for p in raw_dir.iterdir()
        if p.is_file() and not p.name.startswith(".")
    ]
    if not files:
        raise SystemExit(f"No images found in {raw_dir}")

    photos: list[Photo] = []
    errors: list[str] = []
    for path in files:
        try:
            photos.append(parse_photo(path))
        except ValueError as e:
            errors.append(str(e))

    if errors:
        msg = "Invalid photo name(s):\n  " + "\n  ".join(errors)
        raise SystemExit(msg)

    photos.sort()  # by page, then order, then path
    return photos


def group_by_page(photos: list[Photo]) -> list[tuple[int, list[Photo]]]:
    buckets: dict[int, list[Photo]] = defaultdict(list)
    for photo in photos:
        buckets[photo.page].append(photo)
    return sorted(buckets.items(), key=lambda item: item[0])


def scale_to_width(img: Image.Image, width: int) -> Image.Image:
    if img.width == width:
        rgb = img if img.mode == "RGB" else img.convert("RGB")
        return rgb.copy()
    height = max(1, round(img.height * width / img.width))
    scaled = img.resize((width, height), Image.Resampling.LANCZOS)
    return scaled if scaled.mode == "RGB" else scaled.convert("RGB")


def build_page(photos: list[Photo]) -> Image.Image:
    scaled: list[Image.Image] = []
    for photo in photos:
        with Image.open(photo.path) as im:
            im.load()
            scaled.append(scale_to_width(im, PAGE_WIDTH))

    total_height = sum(im.height for im in scaled)
    page = Image.new("RGB", (PAGE_WIDTH, total_height), (255, 255, 255))
    y = 0
    for im in scaled:
        page.paste(im, (0, y))
        y += im.height
        im.close()
    return page


def main() -> None:
    photos = list_photos(RAW_DIR)
    groups = group_by_page(photos)

    pages: list[Image.Image] = []
    try:
        for page_num, group in groups:
            names = ", ".join(p.path.name for p in group)
            print(f"Page {page_num}: {len(group)} image(s) [{names}]")
            pages.append(build_page(group))

        first, rest = pages[0], pages[1:]
        first.save(
            OUT_PDF,
            "PDF",
            save_all=True,
            append_images=rest,
            resolution=72.0,
        )
        print(f"Wrote {OUT_PDF} ({len(pages)} page(s))")
    finally:
        for page in pages:
            page.close()


if __name__ == "__main__":
    main()
    sys.exit(0)
