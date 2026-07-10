#!/usr/bin/env bash
# Responsive fastfetch: scale the braille cat logo to the terminal height.
# fastfetch can't resize a text logo itself, so we regenerate one sized to the
# window (cached per row-count, so it only rebuilds when the size changes) and
# pass it in. Master art: cat-src.txt (high-res). Alias it:  alias ff='~/.config/fastfetch/ff.sh'
set -euo pipefail
D="$HOME/.config/fastfetch"; cd "$D"
SRC="cat-src.txt"

lines=$(tput lines 2>/dev/null || echo 40)
rows=$(( lines - 4 ))
[ "$rows" -gt 32 ] && rows=32
[ "$rows" -lt 12 ] && rows=12

cache="${TMPDIR:-/tmp}/.ffcat-${rows}.txt"
if [ ! -f "$cache" ] || [ "$SRC" -nt "$cache" ]; then
  command -v chafa >/dev/null && command -v magick >/dev/null || { exec fastfetch -c config.jsonc; }
  python3 - "$SRC" > "${cache}.pbm" <<'PY'
import sys
lines=[l for l in open(sys.argv[1],encoding='utf-8').read().split('\n') if l!='']
W=max(len(l) for l in lines);H=len(lines)
bp={0x01:(0,0),0x02:(0,1),0x04:(0,2),0x40:(0,3),0x08:(1,0),0x10:(1,1),0x20:(1,2),0x80:(1,3)}
px=[[0]*(W*2) for _ in range(H*4)]
for y,l in enumerate(lines):
 for x,ch in enumerate(l):
  o=ord(ch)-0x2800
  if 0<=o<=0xFF:
   for b,(cx,cy) in bp.items():
    if o&b: px[y*4+cy][x*2+cx]=1
print("P1");print(W*2,H*4)
for r in px:print(''.join('1'if v else'0'for v in r))
PY
  magick "${cache}.pbm" -negate "${cache}.png"
  ESC=$(printf '\033')
  chafa -f symbols --symbols braille --fg-only -c none -s "200x${rows}" "${cache}.png" \
    | sed "s/${ESC}\[[?0-9;]*[a-zA-Z]//g" > "$cache"
  rm -f "${cache}.pbm" "${cache}.png"
fi

w=$(sed -n '1p' "$cache" | grep -o . | wc -l | tr -d ' ')
exec fastfetch -c config.jsonc \
  --logo "$cache" --logo-type file-raw --logo-width "$w" --logo-height "$rows"
