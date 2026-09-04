#!/bin/bash

set -e

echo "Starting Arclight dotfiles installation..."

if [[ ! -f /etc/arch-release ]]; then
    echo "Error: This installer is designed for Arch Linux."
    exit 1
fi

echo "Arch Linux detected."

packages=(
    awww
    cliphist
    dunst
    hypridle
    hyprland
    hyprlock
    kitty
    nwg-look
    rofi
    thunar
    ttf-orbitron
    waybar
    wl-clipboard
    wlogout
)

echo "Installing packages..."

sudo pacman -S --needed "${packages[@]}"

echo "Packages installed successfully."

echo "Restoring configuration files..."

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-arclight-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CONFIG_DIR"

for item in .config/*; do
    name=$(basename "$item")

    if [[ -e "$CONFIG_DIR/$name" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backing up $name..."
        mv "$CONFIG_DIR/$name" "$BACKUP_DIR/"
    fi

    cp -r "$item" "$CONFIG_DIR/"
done

if [[ -d "$BACKUP_DIR" ]]; then
    echo "Existing configuration backed up to:"
    echo "$BACKUP_DIR"
fi

echo "Configuration files restored successfully."