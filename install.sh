#!/bin/bash

source ./helper.sh

install_paru

echo "::Update mirrors..."
sudo pacman -Syyu

install_grub_btrfs

echo "::Installing Essntial packages..."
source ./packages/essential.sh

install_packages "${packages[@]}"

create_snapshot "Pre-installation"

echo "::Installing Hyprland packages..."
source ./packages/hyprland.sh

install_packages "${packages[@]}"

echo "::Installing GUI packages..."
source ./packages/gui.sh

install_packages "${packages[@]}"

echo "::Installing fonts..."

source ./packages/fonts.sh

install_packages "${packages[@]}"

echo "::Installing Portal packages..."
source ./packages/portal.sh

install_packages "${packages[@]}"

echo "::Installing SDDM..."
source ./packages/sddm.sh

install_packages "${packages[@]}"

echo "::Installing SDDM Theme..."

source ./sddm-sequoia/install_theme.sh

enable_sddm

echo "::Installing tools..."
source ./packages/tools.sh

install_packages "${packages[@]}"

create_snapshot "Post-installation"

setup_ufw

create_snapshot "Completed-installation"

change_shell

install_oh_my_zsh

install_fnm

install_pnpm

install_pyenv

stow_dotfiles

install_wallpaper

cleanup

echo ":: Creating Hyprland desktop entry if doesn't exist..."

if [ ! -f /usr/share/wayland-sessions/hyprland-uwsm.desktop ]; then
  curl https://raw.githubusercontent.com/hyprwm/Hyprland/refs/heads/main/systemd/hyprland-uwsm.desktop >hyprland-uwsm.desktop
  sudo cp hyprland-uwsm.desktop /usr/share/wayland-sessions/hyprland-uwsm.desktop
  rm hyprland-uwsm.desktop
fi

echo ":: Installation complete."
echo "rebooting..."

pywalfox install --browser librewolf

sleep 3
systemctl reboot
