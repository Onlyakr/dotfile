#!/usr/bin/env bash
# Render the cat image into monochrome dot-art (braille) for rice.sh + nvim.
# Dot DENSITY carries the shape (transparent gaps where dark), so the subject
# reads as a cat plotted in a dot field — like the reference.
#
# Swap the cat: drop your image as fastfetch/logo-src.<ext>, then ./gen-logo.sh.
# A subject that fills the frame with clear light/dark contrast reads best.
set -euo pipefail
cd "$(dirname "$0")"

SIZE="34x17"          # art size in terminal cells; width must match CAT_W in rice.sh
CROP=500              # square edge (px) the image is cropped/filled to

src=$(ls logo-src.* 2>/dev/null | grep -v '\.sh$' | head -1)
[ -z "$src" ] && { echo "no logo-src.* found in $(pwd)"; exit 1; }
command -v chafa >/dev/null || { echo "chafa not installed (brew install chafa)"; exit 1; }

work="$(mktemp).png"
if command -v magick >/dev/null; then
  magick "$src" -colorspace Gray -resize "${CROP}x${CROP}^" -gravity center -extent "${CROP}x${CROP}" "$work"
else
  sips -Z "$CROP" -c "$CROP" "$CROP" "$src" --out "$work" >/dev/null
  sips --matchTo '/System/Library/ColorSync/Profiles/Generic Gray Profile.icc' "$work" --out "$work" >/dev/null
fi

ESC=$(printf '\033')
chafa -f symbols --symbols braille --fg-only -c none -s "$SIZE" "$work" \
  | sed "s/${ESC}\[[?0-9;]*[a-zA-Z]//g" | tee cat.txt > ../nvim/cat.txt

rm -f "$work"
echo "wrote cat.txt + ../nvim/cat.txt from $src ($SIZE)"
