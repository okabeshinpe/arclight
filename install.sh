#!/bin/bash

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Starting Arclight dotfiles installation..."

if [[ ! -f /etc/arch-release ]]; then
    echo "Error: This installer is designed for Arch Linux."
    exit 1
fi

echo "Arch Linux detected."

packages=(
    base-devel
    git
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
    waybar
    wl-clipboard
)

aur_packages=(
    ttf-orbitron
    wlogout
)

echo "Installing packages..."

sudo pacman -S --needed "${packages[@]}"

echo "Packages installed successfully."

if ! command -v paru &> /dev/null; then
    echo "paru not found. Installing paru..."

PARU_DIR="$(mktemp -d)"

git clone https://aur.archlinux.org/paru.git "$PARU_DIR"
cd "$PARU_DIR"
makepkg -si --noconfirm
cd -
rm -rf "$PARU_DIR"

fi

echo "Installing AUR packages..."

paru -S --needed "${aur_packages[@]}"

echo "AUR packages installed successfully."

echo "Restoring configuration files..."

CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-arclight-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CONFIG_DIR"

for item in "$SCRIPT_DIR"/.config/*; do
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