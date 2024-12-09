#!/bin/bash

# Define threshholds for color indicators
threshhold_green=0
threshhold_yellow=50
threshhold_red=100

# Calculate available updates
updates=0
updates=$((updates + "$(checkupdates 2>/dev/null | wc -l || 0)"))
sleep 1
updates=$((updates + "$(paru -Qu --aur --quiet | wc -l || 0)"))
sleep 1
updates=$((updates + "$(flatpak remote-ls --updates 2>/dev/null | wc -l || 0)"))
sleep 1

# Output in JSON format for Waybar Module custom-updates
css_class="green"

if [ "$updates" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$updates" -gt $threshhold_red ]; then
    css_class="red"
fi

if [ "$updates" -gt $threshhold_green ]; then
    printf '{"text": "%s", "alt": "%s", "tooltip": "Click to update your system", "class": "%s"}' "$updates" "$updates" "$css_class"
else
    printf '{"text": "0", "alt": "0", "tooltip": "No updates available", "class": "green"}'
fi
