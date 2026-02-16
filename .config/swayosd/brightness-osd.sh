#!/bin/bash
set -euo pipefail

# brightnessctl -m output is CSV; column 4 is percentage (e.g. "42%")
brightness_percent="$(brightnessctl -m | awk -F, 'NR==1 {gsub("%","",$4); print $4}')"

if [ -z "${brightness_percent}" ]; then
    exit 0
fi

# Convert to 0.0..1.0 for SwayOSD progress rendering.
brightness_progress="$(awk -v p="${brightness_percent}" 'BEGIN { printf "%.3f", p/100 }')"

swayosd-client \
    --custom-progress "${brightness_progress}" \
    --custom-progress-text "${brightness_percent}%" \
    --custom-icon "display-brightness-symbolic"
