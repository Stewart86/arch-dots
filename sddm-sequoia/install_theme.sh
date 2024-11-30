#!/bin/bash

clear
echo -e "${GREEN}"
figlet -f smslant "SDDM Theme"
echo -e "${NONE}"

sddm_theme_name="sequoia"
sddm_theme_master="main.zip"
sddm_theme_folder="sddm-sequoia-main"
sddm_theme_download="https://github.com/minMelody/sddm-sequoia/archive/refs/heads/main.zip"
sddm_asset_folder="/usr/share/sddm/themes/$sddm_theme_name/backgrounds"
# sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sequoia

sddm_theme_tpl="./theme.conf"
if [ -f "$HOME"/.config/ml4w/settings/sddm/theme.conf ]; then
  sddm_theme_tpl="$HOME/.config/ml4w/settings/sddm/theme.conf"
  echo ":: Using custum theme.conf"
fi

if [ -d /usr/share/sddm/themes/$sddm_theme_name ]; then
  echo ":: $sddm_theme_name theme is already installed"
  echo
fi
if [ -d /usr/share/sddm ]; then
  if gum confirm "Do you want to install the $sddm_theme_name theme?"; then
    echo ":: Installing $sddm_theme_name"

    if [ -d ~/Downloads/$sddm_theme_name ]; then
      rm -rf ~/Downloads/$sddm_theme_name
      echo ":: ~/Downloads/$sddm_theme_name removed"
    fi

    wget -P ~/Downloads/$sddm_theme_name $sddm_theme_download
    echo ":: Download of $sddm_theme_name complete"
    unzip -o -q ~/Downloads/$sddm_theme_name/$sddm_theme_master -d ~/Downloads/$sddm_theme_name
    echo ":: Unzip of $sddm_theme_name complete"

    sudo cp -r ~/Downloads/$sddm_theme_name/$sddm_theme_folder /usr/share/sddm/themes/$sddm_theme_name
    echo ":: $sddm_theme_name copied to target location"

    if [ ! -d /etc/sddm.conf.d/ ]; then
      sudo mkdir /etc/sddm.conf.d
      echo "Folder /etc/sddm.conf.d created."
    fi

    sudo cp ./sddm.conf /etc/sddm.conf.d/
    echo "File /etc/sddm.conf.d/sddm.conf updated."

    if [ -f /usr/share/sddm/themes/$sddm_theme_name/theme.conf ]; then

      # Cache file for holding the current wallpaper
      sudo cp ./default.jpg $sddm_asset_folder/current_wallpaper.jpg
      echo "Default wallpaper copied into $sddm_asset_folder"

      sudo cp "$sddm_theme_tpl" /usr/share/sddm/themes/$sddm_theme_name/
      sudo sed -i 's/CURRENTWALLPAPER/'"current_wallpaper.jpg"'/' /usr/share/sddm/themes/$sddm_theme_name/theme.conf
      echo "File theme.conf updated in /usr/share/sddm/themes/$sddm_theme_name/"

    fi
    echo
    gum spin --spinner dot --title "Please reboot your system." -- sleep 3
  fi
else
  gum spin --spinner dot --title "SDDM (/usr/share/sddm) not found" -- sleep 3
fi
# _selectCategory
