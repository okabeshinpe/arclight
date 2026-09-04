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