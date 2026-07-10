#!/usr/bin/env bash
# Render the cat into monochrome dot-art (braille) for fastfetch + nvim.
#
# Source can be either:
#   logo-src.txt  - ASCII art; it's rasterised and blurred so the character
#                   density becomes tone, then dithered (the art is the reference).
#   logo-src.<img>- a photo/image, dithered directly.
# Density carries the shape, so the cat reads as dots in a field.
#
# Swap the cat: replace logo-src.txt (or drop a logo-src.<img>) and run ./gen-logo.sh.
set -euo pipefail
cd "$(dirname "$0")"

SIZE="28x34"          # art size in terminal cells
BLUR="0x5"            # ASCII-only: higher = smoother tone, lower = more texture
FONT="/System/Library/Fonts/Menlo.ttc"   # ASCII-only: a monospace so the art stays aligned

command -v chafa >/dev/null || { echo "chafa not installed (brew install chafa)"; exit 1; }
command -v magick >/dev/null || { echo "imagemagick not installed (brew install imagemagick)"; exit 1; }

work="$(mktemp).png"
if [ -f logo-src.txt ]; then
  magick -background black -fill white -font "$FONT" -pointsize 14 label:@logo-src.txt \
    -blur "$BLUR" -normalize "$work"
else
  src=$(ls logo-src.* 2>/dev/null | grep -v '\.sh$' | head -1)
  [ -z "$src" ] && { echo "no logo-src.* found in $(pwd)"; exit 1; }
  magick "$src" -colorspace Gray -resize 500x500^ -gravity center -extent 500x500 "$work"
fi

ESC=$(printf '\033')
chafa -f symbols --symbols braille --fg-only -c none -s "$SIZE" "$work" \
  | sed "s/${ESC}\[[?0-9;]*[a-zA-Z]//g" | tee cat.txt > ../nvim/cat.txt

rm -f "$work"
echo "wrote cat.txt + ../nvim/cat.txt ($SIZE)"
