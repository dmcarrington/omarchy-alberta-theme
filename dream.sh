#!/bin/bash
# dream.sh <in> <out> <width> <duo%> <sat> <glow%> <gamma> <skycolor> <vignette%> [hue]
# Dreamlike grade: teal/glacial duotone wash, cool sky gradient, saturation
# boost, Orton glow (screen-blended blur), and a soft dark vignette.
set -e
in=$1; out=$2; w=$3; duo=$4; sat=$5; glow=$6; gamma=$7; sky=$8; vig=$9; hue=${10:-100}
h=$(( w * 2 / 3 ))
r=$(( w / 110 ))   # glow radius scales with output size
magick "$in" -auto-orient -resize "${w}x${h}^" -gravity center -extent "${w}x${h}" \
  -contrast-stretch 0.3%x0.3% \
  \( +clone -colorspace gray +level-colors '#03201f','#d2f1ff' \) \
    -compose blend -define compose:args=$duo -composite \
  \( -size "${w}x${h}" gradient:"$sky"-white -evaluate pow 0.8 \) -compose multiply -composite \
  -modulate 100,$sat,$hue \
  -sigmoidal-contrast 5x40% \
  \( +clone -blur 0x$r -modulate 105,125 \) \
  \( -clone 0 -clone 1 -compose screen -composite \) -delete 1 \
  -compose blend -define compose:args=$glow -composite \
  -gamma $gamma \
  \( -size "${w}x${h}" radial-gradient:white-"gray($vig%)" -evaluate pow 1.2 \) -compose multiply -composite \
  -quality 93 "$out"
