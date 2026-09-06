#!/usr/bin/env bash
set -euo pipefail

CURRENT_WALLPAPER="$(awww query | grep -oP 'image: \K.*')"

if [[ -z "$CURRENT_WALLPAPER" || ! -f "$CURRENT_WALLPAPER" ]]; then
    echo "Could not determine current wallpaper." >&2
    exit 1
fi

sed -i "s|^[[:space:]]*path = .*|    path = $CURRENT_WALLPAPER|" "$HOME/.config/hypr/hyprlock.conf"

exec hyprlock
