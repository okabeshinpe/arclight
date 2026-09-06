#!/usr/bin/env bash
set -euo pipefail

LOG="/tmp/lock-debug.log"
echo "--- lock.sh run at $(date) ---" >> "$LOG"
echo "PATH=$PATH" >> "$LOG"
echo "HOME=$HOME" >> "$LOG"

RAW_QUERY="$(awww query 2>&1)"
echo "RAW_QUERY=$RAW_QUERY" >> "$LOG"

CURRENT_WALLPAPER="$(echo "$RAW_QUERY" | grep -oP 'image: \K.*' || true)"
echo "CURRENT_WALLPAPER=$CURRENT_WALLPAPER" >> "$LOG"

if [[ -n "$CURRENT_WALLPAPER" && -f "$CURRENT_WALLPAPER" ]]; then
    sed -i "s|^[[:space:]]*path = .*|    path = $CURRENT_WALLPAPER|" "$HOME/.config/hypr/hyprlock.conf"
    echo "sed applied" >> "$LOG"
else
    echo "condition failed, skipping sed" >> "$LOG"
fi

exec hyprlock
