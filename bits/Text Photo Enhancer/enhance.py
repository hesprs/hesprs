"""
Batch photo enhancer approximating iPhone Photos:
  Brilliance → max (+100)
  Shadows   → negative max (-100)

Reads  Bits/Text Photo Enhancer/Raw/*
Writes Bits/Text Photo Enhancer/Processed/*  (overwrite)
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

RAW_DIR = Path(__file__).resolve().parent / "Raw"
OUT_DIR = Path(__file__).resolve().parent / "Processed"

# Common photo formats Pillow can open without extra plugins.
EXTENSIONS = {".jpg", ".jpeg", ".png", ".webp", ".tif", ".tiff", ".bmp", ".gif"}

# --- strength knobs (tuned for "slider at extreme") ---
# Brilliance max: lift darks, pull highlights, midtone contrast, local detail
BRILLIANCE_SHADOW_LIFT = 0.55
BRILLIANCE_HIGHLIGHT_PULL = 0.40
BRILLIANCE_MID_CONTRAST = 1.22
BRILLIANCE_LOCAL_AMOUNT = 0.42
BRILLIANCE_LOCAL_RADIUS = 8  # Gaussian blur radius for local contrast

# Shadows negative max: crush deep/near-black tones
SHADOWS_CRUSH = 0.85
SHADOWS_RANGE = 0.50  # tones below this (0–1) are affected


def srgb_to_linear(c: np.ndarray) -> np.ndarray:
    return np.where(c <= 0.04045, c / 12.92, ((c + 0.055) / 1.055) ** 2.4)


def linear_to_srgb(c: np.ndarray) -> np.ndarray:
    return np.where(c <= 0.0031308, 12.92 * c, 1.055 * np.power(np.clip(c, 0, None), 1 / 2.4) - 0.055)


def luminance_linear(rgb_lin: np.ndarray) -> np.ndarray:
    # Rec. 709
    return 0.2126 * rgb_lin[..., 0] + 0.7152 * rgb_lin[..., 1] + 0.0722 * rgb_lin[..., 2]


def apply_luma_map(rgb_lin: np.ndarray, y_new: np.ndarray) -> np.ndarray:
    y = luminance_linear(rgb_lin)
    scale = np.ones_like(y)
    np.divide(y_new, y, out=scale, where=y > 1e-8)
    return rgb_lin * scale[..., None]


def brilliance_curve(y: np.ndarray) -> np.ndarray:
    """
    Global tone map approximating Brilliance at +100 (color-neutral):
    - lift shadows / lower midtones
    - compress highlights
    - mild S-curve midtone contrast
    """
    y = np.clip(y, 0.0, 1.0)

    # Shadow lift: strongest in darks, fades toward white
    lift = BRILLIANCE_SHADOW_LIFT * (1.0 - y) ** 2 * (0.35 + 0.65 * y)
    lifted = y + lift

    # Highlight pull: soft shoulder near white
    pull = BRILLIANCE_HIGHLIGHT_PULL
    compressed = lifted / (1.0 + pull * lifted) * (1.0 + pull)

    # Midtone contrast (S-curve around 0.5)
    c = BRILLIANCE_MID_CONTRAST
    contrasted = np.clip((compressed - 0.5) * c + 0.5, 0.0, 1.0)
    return contrasted


def local_contrast(y: np.ndarray) -> np.ndarray:
    """Edge-ish local contrast (clarity-like), part of Brilliance 'reveal detail'."""
    # Work in 8-bit for PIL blur, then back.
    y8 = np.clip(y * 255.0, 0, 255).astype(np.uint8)
    blur = np.asarray(
        Image.fromarray(y8, mode="L").filter(
            ImageFilter.GaussianBlur(radius=BRILLIANCE_LOCAL_RADIUS)
        ),
        dtype=np.float64,
    ) / 255.0
    detail = y - blur
    return np.clip(y + BRILLIANCE_LOCAL_AMOUNT * detail, 0.0, 1.0)


def shadows_negative_max(y: np.ndarray) -> np.ndarray:
    """
    Approximate Shadows at -100: deepen dark tones, leave highlights alone.
    """
    y = np.clip(y, 0.0, 1.0)
    # 1 at black → 0 at SHADOWS_RANGE
    mask = np.clip(1.0 - y / SHADOWS_RANGE, 0.0, 1.0)
    mask = mask**1.15
    factor = 1.0 - SHADOWS_CRUSH * mask
    return np.clip(y * factor, 0.0, 1.0)


def enhance(img: Image.Image) -> Image.Image:
    has_alpha = img.mode in ("RGBA", "LA") or (img.mode == "P" and "transparency" in img.info)
    if has_alpha:
        rgba = img.convert("RGBA")
        rgb = rgba.convert("RGB")
        alpha = rgba.getchannel("A")
    else:
        rgb = img.convert("RGB")
        alpha = None

    arr = np.asarray(rgb, dtype=np.float64) / 255.0
    lin = srgb_to_linear(arr)
    y = luminance_linear(lin)

    # 1) Brilliance max
    y = brilliance_curve(y)
    y = local_contrast(y)

    # 2) Shadows negative max
    y = shadows_negative_max(y)

    out_lin = apply_luma_map(lin, y)
    out_srgb = np.clip(linear_to_srgb(out_lin), 0.0, 1.0)
    out_u8 = (out_srgb * 255.0 + 0.5).astype(np.uint8)
    result = Image.fromarray(out_u8, mode="RGB")

    if alpha is not None:
        result = result.convert("RGBA")
        result.putalpha(alpha)

    return result


def iter_inputs() -> list[Path]:
    if not RAW_DIR.is_dir():
        raise SystemExit(f"Missing input folder: {RAW_DIR}")
    files = sorted(
        p
        for p in RAW_DIR.iterdir()
        if p.is_file() and p.suffix.lower() in EXTENSIONS and not p.name.startswith(".")
    )
    return files


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    inputs = iter_inputs()
    if not inputs:
        print(f"No images in {RAW_DIR}")
        print(f"Supported: {', '.join(sorted(EXTENSIONS))}")
        return

    for src in inputs:
        dst = OUT_DIR / src.name
        print(f"{src.name} → Processed/{src.name}")
        with Image.open(src) as im:
            # Load fully so file can close before write (same-name edge cases)
            im.load()
            out = enhance(im)
            # Preserve format when possible; default JPEG quality high for photos
            save_kw: dict = {}
            fmt = (im.format or src.suffix.lstrip(".")).upper()
            if fmt in ("JPG", "JPEG"):
                save_kw.update(quality=95, optimize=True, subsampling=0)
                fmt = "JPEG"
            elif fmt == "PNG":
                save_kw.update(optimize=True)
            elif fmt == "WEBP":
                save_kw.update(quality=95, method=6)
            out.save(dst, format=fmt if fmt != "JPG" else "JPEG", **save_kw)

    print(f"Done. {len(inputs)} file(s) → {OUT_DIR}")


if __name__ == "__main__":
    main()
