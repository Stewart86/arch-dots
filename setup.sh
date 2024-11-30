#!/bin/bash

echo "::Pulling from git..."
sudo pacman -S --noconfirm git
git clone https://github.com/Stewart86/arch-dots.git "$HOME"/dotfiles

echo "Successfully pulled from install.sh from git."
ehco "Changing directory to $HOME/dotfiles..."
cd "$HOME"/dotfiles || exit

chmod +x install.sh
echo "Running install.sh..."
./install.sh
