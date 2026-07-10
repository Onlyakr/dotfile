#!/usr/bin/env bash
# Resize the braille cat in cat.txt to a target row count (default 28, ≈ the
# fastfetch info column height) so the logo doesn't dangle below the info.
# Reconstructs the real bitmap from the braille dots (each char = 2x4 dots),
# then re-dithers smaller — lossless, unlike re-rasterising the glyphs.
#
# Usage: ./fit-cat.sh [rows] [file]        (default rows=28, file=cat.txt)
#        COLS=60 ./fit-cat.sh 22           widen: stretch to exact COLS x rows
#        ./fit-cat.sh 18 ../nvim/cat.txt   the nvim dashboard cat
# For fastfetch, set width/height in config.jsonc to what it prints.
set -euo pipefail
cd "$(dirname "$0")"
ROWS="${1:-28}"
FILE="${2:-cat.txt}"
COLS="${COLS:-0}"   # 0 = keep aspect; >0 = stretch to exactly COLSxROWS (fixes proportion)
command -v chafa >/dev/null || { echo "need chafa"; exit 1; }
command -v magick >/dev/null || { echo "need imagemagick"; exit 1; }

python3 - "$FILE" > /tmp/.fitcat.pbm <<'PY'
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
if [ "$COLS" -gt 0 ]; then
  SIZE_ARGS=(--stretch -s "${COLS}x${ROWS}")   # exact size, fixes proportion
else
  SIZE_ARGS=(-s "200x${ROWS}")                 # keep aspect, width auto
fi
chafa -f symbols --symbols braille --fg-only -c none "${SIZE_ARGS[@]}" /tmp/.fitcat.png \
  | sed "s/${ESC}\[[?0-9;]*[a-zA-Z]//g" > "$FILE"
rm -f /tmp/.fitcat.pbm /tmp/.fitcat.png

h=$(wc -l < "$FILE"); w=$(sed -n '1p' "$FILE" | grep -o . | wc -l | tr -d ' ')
echo "$FILE resized -> ${w}x${h} (for fastfetch set config.jsonc logo width=$w height=$h)"
