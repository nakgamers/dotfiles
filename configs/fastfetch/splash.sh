#!/bin/bash
SMALL="$HOME/.config/fastfetch/rayneshia-small.png"
kitty +kitten icat --align left "$SMALL" 2>/dev/null
tput cuu 5
fastfetch --logo none -s "OS:Kernel:Uptime:CPU:Memory" | while IFS= read -r line; do
  tput hpa 17
  printf '%s\n' "$line"
done
