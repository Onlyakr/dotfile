#!/usr/bin/env bash
# Two-panel monochrome fetch, ref-style: [ dot-art cat box ]  [ spec box ].
# fastfetch can't draw a border around its info, so we render the info with
# --pipe and box both panels here, then paste them side by side.
#
# Alias it:  alias si='~/.config/fastfetch/rice.sh'
set -euo pipefail
cd "$(dirname "$0")"

CAT_W=34                 # must match SIZE width in gen-logo.sh
ESC=$(printf '\033')
GAP="  "                 # space between the two boxes

repeat() { local n=$1 c=$2 s=""; while [ "$n" -gt 0 ]; do s="$s$c"; n=$((n-1)); done; printf '%s' "$s"; }

# ---- left panel: cat box (art already generated into cat.txt) ----
{
  bar=$(repeat $((CAT_W + 2)) "─")
  printf '╭%s╮\n' "$bar"
  while IFS= read -r line || [ -n "$line" ]; do
    printf '│ %s%s │\n' "$line" "${ESC}[0m"
  done < cat.txt
  printf '╰%s╯\n' "$bar"
} > /tmp/.rice_left.$$

# ---- right panel: spec box (fastfetch --pipe, key/value right-aligned) ----
fastfetch -c info.jsonc --pipe 2>/dev/null \
  | sed "s/${ESC}\[[0-9;]*[A-Za-z]//g" \
  | awk -F'\t' -v foot="=^.^=   stay libre" '
      function pad(s, w,  p){ p=""; while(length(s)+length(p) < w) p=p" "; return s p }
      BEGIN { n=0 }
      NF>=2 { k[n]=$1; v[n]=$2; n++;
              w=length($1)+3+length($2); if(w>mw) mw=w }
      END {
        if (mw < length(foot)) mw = length(foot)
        bar=""; for(i=0;i<mw+2;i++) bar=bar"─"
        print "╭" bar "╮"
        for(i=0;i<n;i++){
          gap=mw-length(k[i])-length(v[i])
          p=""; for(j=0;j<gap;j++) p=p" "
          print "│ " k[i] p v[i] " │"
        }
        print "│ " pad("", mw) " │"
        print "│ " pad(foot, mw) " │"
        print "╰" bar "╯"
      }' > /tmp/.rice_right.$$

# ---- vertically centre the shorter panel, then paste ----
ln=$(wc -l < /tmp/.rice_left.$$); rn=$(wc -l < /tmp/.rice_right.$$)
lw=$((CAT_W + 4))
blank_l=$(repeat "$lw" " ")
top=0; [ "$ln" -gt "$rn" ] && top=$(( (ln - rn) / 2 ))

awk -v top="$top" -v blank="$blank_l" -v gap="$GAP" '
  NR==FNR { L[FNR]=$0; ln=FNR; next }
  { R[FNR+top]=$0; if (FNR+top>rn) rn=FNR+top }
  END {
    max = ln; if (rn>max) max=rn
    for (i=1;i<=max;i++){
      left = (i in L) ? L[i] : blank
      right = (i in R) ? R[i] : ""
      print left gap right
    }
  }' /tmp/.rice_left.$$ /tmp/.rice_right.$$

rm -f /tmp/.rice_left.$$ /tmp/.rice_right.$$
