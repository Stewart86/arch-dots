#!/bin/bash
# Update end-4 dots-hyprland

set -e

DOTS_DIR="$HOME/.cache/dots-hyprland"

if [[ ! -d "$DOTS_DIR" ]]; then
    echo "Error: dots-hyprland not found at $DOTS_DIR"
    exit 1
fi

cd "$DOTS_DIR"
echo "Stashing local changes..."
git stash
echo "Pulling latest changes..."
git pull
echo "Running install script..."
./setup install
