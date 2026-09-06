#!/bin/bash

set -e

if [[ $EUID -eq 0 ]]; then
    echo "Error: Do not run this installer as root."
    exit 1
fi

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
    sudo
    awww
    brightnessctl
    grim
    ffmpeg
    pipewire
    wireplumber
    hyprpolkitagent
    slurp
    xdg-desktop-portal-hyprland
    papirus-icon-theme
    playerctl
    qt5ct
    ttc-iosevka
    ttf-iosevka-nerd
    ttf-jetbrains-mono-nerd
    cliphist
    dunst
    hypridle
    hyprland
    hyprlock
    imagemagick
    kitty
    nwg-look
    pavucontrol
    python
    qt6-multimedia
    rofi
    thunar
    waybar
    wl-clipboard
    xdg-utils
)

aur_packages=(
    bibata-cursor-theme
    mpvpaper
    quickshell
    ttf-orbitron
    wlogout
    zen-browser-bin
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

echo "Setting up wallpaper picker..."

PICKER_DIR="$SCRIPT_DIR/apps/qs-wallpaper-picker"

if [[ ! -f "$PICKER_DIR/config/Settings.qml" ]]; then
    cp "$PICKER_DIR/config/Settings.qml.example" \
       "$PICKER_DIR/config/Settings.qml"
fi

chmod +x "$PICKER_DIR/scripts/open_picker.sh"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Wallpapers"

cat > "$HOME/.local/bin/arclight-wallpaper-picker" <<EOF
#!/usr/bin/env bash
exec "$PICKER_DIR/scripts/open_picker.sh" "\$@"
EOF

chmod +x "$HOME/.local/bin/arclight-wallpaper-picker"

echo "Wallpaper picker configured."

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
