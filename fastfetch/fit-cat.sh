#!/usr/bin/env bash
# Resize the braille cat in cat.txt to a target row count (default 28, ≈ the
# fastfetch info column height) so the logo doesn't dangle below the info.
# Reconstructs the real bitmap from the braille dots (each char = 2x4 dots),
# then re-dithers smaller — lossless, unlike re-rasterising the glyphs.
#
# Usage: ./fit-cat.sh [rows]   then set width/height in config.jsonc to the
#        dimensions it prints.
set -euo pipefail
cd "$(dirname "$0")"
ROWS="${1:-28}"
command -v chafa >/dev/null || { echo "need chafa"; exit 1; }
command -v magick >/dev/null || { echo "need imagemagick"; exit 1; }

python3 - "$PWD/cat.txt" > /tmp/.fitcat.pbm <<'PY'
import sys
lines=[l for l in open(sys.argv[1],encoding='utf-8').read().split('\n') if l!='']
W=max(len(l) for l in lines); H=len(lines)
bitpos={0x01:(0,0),0x02:(0,1),0x04:(0,2),0x40:(0,3),0x08:(1,0),0x10:(1,1),0x20:(1,2),0x80:(1,3)}
px=[[0]*(W*2) for _ in range(H*4)]
for y,l in enumerate(lines):
    for x,ch in enumerate(l):
        o=ord(ch)-0x2800
        if 0<=o<=0xFF:
            for bit,(cx,cy) in bitpos.items():
                if o&bit: px[y*4+cy][x*2+cx]=1
print("P1"); print(W*2,H*4)
for r in px: print(''.join('1' if v else '0' for v in r))
PY

magick /tmp/.fitcat.pbm -negate /tmp/.fitcat.png
ESC=$(printf '\033')
chafa -f symbols --symbols braille --fg-only -c none -s "200x${ROWS}" /tmp/.fitcat.png \
  | sed "s/${ESC}\[[?0-9;]*[a-zA-Z]//g" > cat.txt
rm -f /tmp/.fitcat.pbm /tmp/.fitcat.png

h=$(wc -l < cat.txt); w=$(sed -n '1p' cat.txt | grep -o . | wc -l | tr -d ' ')
echo "cat.txt resized -> set config.jsonc logo width=$w height=$h"
