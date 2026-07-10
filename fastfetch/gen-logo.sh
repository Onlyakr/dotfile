#!/usr/bin/env bash
# Regenerate the fastfetch cat logo as greyscale dot-art (braille) into cat.txt.
#
# Swap the cat: drop your own image as fastfetch/logo-src.<ext> (front-facing,
# high contrast, plain background renders cleanest), then run ./gen-logo.sh.
# Tune size with WIDTHxHEIGHT below.
set -euo pipefail
cd "$(dirname "$0")"

SIZE="34x17"
src=$(ls logo-src.* 2>/dev/null | grep -v '\.sh$' | head -1)
[ -z "$src" ] && { echo "no logo-src.* found in $(pwd)"; exit 1; }
command -v chafa >/dev/null || { echo "chafa not installed (brew install chafa)"; exit 1; }

gray="$(mktemp).png"
sips -s format png "$src" --out "$gray" >/dev/null
# desaturate so the dots carry only brightness, no hue (pure mono)
sips --matchTo '/System/Library/ColorSync/Profiles/Generic Gray Profile.icc' "$gray" --out "$gray" >/dev/null

ESC=$(printf '\033')
# --fg-only = shaded dots on a transparent bg (blends with terminal, like the ref)
chafa -f symbols --symbols braille --fg-only -c 256 -s "$SIZE" "$gray" \
  | sed "s/${ESC}\[?25[lh]//g" > cat.txt   # strip chafa's cursor hide/show
rm -f "$gray"
echo "wrote cat.txt from $src ($SIZE)"
