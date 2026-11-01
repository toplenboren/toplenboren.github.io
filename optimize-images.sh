#!/usr/bin/env bash
# Re-encode static/ images to AVIF, capped at ~2x display size. Keeps originals.
# Requires ImageMagick built with AVIF/HEIC support (apt: imagemagick + libheif-plugin-aomenc, brew: imagemagick).
set -euo pipefail
cd "$(dirname "$0")"

magick=$(command -v magick || command -v convert) || { echo "imagemagick not found" >&2; exit 1; }

for src in static/*.jpg static/*.png; do
  dst="${src%.*}.avif"
  [ "$dst" -nt "$src" ] && continue
  max=1200
  [ "$(basename "$src")" = "avatar2.jpg" ] && max=288
  "$magick" "$src" -auto-orient -resize "${max}x${max}>" -strip -quality 50 "$dst"
  echo "$src -> $dst ($(du -h "$dst" | cut -f1))"
done
