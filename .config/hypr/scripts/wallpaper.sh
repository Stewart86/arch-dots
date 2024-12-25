#!/bin/bash
#                _ _
# __      ____ _| | |_ __   __ _ _ __   ___ _ __
# \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#  \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#   \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                   |_|         |_|
#
# -----------------------------------------------------
# Check to use wallpaper cache
# -----------------------------------------------------

use_cache=1

# -----------------------------------------------------
# Set defaults
# -----------------------------------------------------

force_generate=0
generatedversions="$HOME/.cache/wallpaper/wallpaper-generated"
waypaperrunning=$HOME/.cache/wallpaper/waypaper-running
cachefile="$HOME/.cache/wallpaper/current_wallpaper"
blurredwallpaper="$HOME/.cache/wallpaper/blurred_wallpaper.png"
squarewallpaper="$HOME/.cache/wallpaper/square_wallpaper.png"
rasifile="$HOME/.cache/wallpaper/current_wallpaper.rasi"
defaultwallpaper="$HOME/wallpaper/default.jpg"
blur="50x30"

# Ensure that the wallpaper directory exists
if [ ! -d "$HOME/.cache/wallpaper" ]; then
    mkdir "$HOME/.cache/wallpaper"
fi

# Ensures that the script only run once if wallpaper effect enabled
if [ -f "$waypaperrunning" ]; then
    rm "$waypaperrunning"
    exit
fi

# Create folder with generated versions of wallpaper if not exists
if [ ! -d "$generatedversions" ]; then
    mkdir "$generatedversions"
fi

# -----------------------------------------------------
# Get selected wallpaper
# -----------------------------------------------------

if [ -z "$1" ]; then
    if [ -f "$cachefile" ]; then
        wallpaper=$(cat "$cachefile")
    else
        wallpaper=$defaultwallpaper
    fi
else
    wallpaper=$1
fi
used_wallpaper=$wallpaper
echo ":: Setting wallpaper with source image $wallpaper"
tmpwallpaper=$wallpaper

# -----------------------------------------------------
# Copy path of current wallpaper to cache file
# -----------------------------------------------------

if [ ! -f "$cachefile" ]; then
    touch "$cachefile"
fi
echo "$wallpaper" >"$cachefile"
echo ":: Path of current wallpaper copied to $cachefile"

# -----------------------------------------------------
# Get wallpaper filename
# -----------------------------------------------------
wallpaperfilename=$(basename "$wallpaper")
echo ":: Wallpaper Filename: $wallpaperfilename"

# -----------------------------------------------------
# Execute pywal
# -----------------------------------------------------

echo ":: Execute pywal with $used_wallpaper"
wal -q -i "$used_wallpaper"
# shellcheck source=/dev/null
source "$HOME/.cache/wal/colors.sh"

# -----------------------------------------------------
# Reload Waybar
# -----------------------------------------------------

killall -SIGUSR2 waybar

# -----------------------------------------------------
# Pywalfox
# -----------------------------------------------------

if type pywalfox >/dev/null 2>&1; then
    pywalfox update
fi

# -----------------------------------------------------
# Created blurred wallpaper
# -----------------------------------------------------

if [ -f "$generatedversions/blur-$blur-$wallpaperfilename.png" ] && [ "$force_generate" == "0" ] && [ "$use_cache" == "1" ]; then
    echo ":: Use cached wallpaper blur-$blur-$wallpaperfilename"
else
    echo ":: Generate new cached wallpaper blur-$blur-$wallpaperfilename with blur $blur"
    dunstify "Generate new blurred version" "with blur $blur" -h int:value:66 -h string:x-dunst-stack-tag:wallpaper
    magick "$used_wallpaper" -resize 75% "$blurredwallpaper"
    echo ":: Resized to 75%"
    magick "$blurredwallpaper" -blur "$blur" "$blurredwallpaper"
    cp "$blurredwallpaper" "$generatedversions/blur-$blur-$wallpaperfilename.png"
    echo ":: Blurred"
fi
cp "$generatedversions/blur-$blur-$wallpaperfilename.png" "$blurredwallpaper"

# -----------------------------------------------------
# Create rasi file
# -----------------------------------------------------

if [ ! -f "$rasifile" ]; then
    touch "$rasifile"
fi
echo "* { current-image: url(\"$blurredwallpaper\", height); }" >"$rasifile"

# -----------------------------------------------------
# Created square wallpaper
# -----------------------------------------------------

echo ":: Generate new cached wallpaper square-$wallpaperfilename"
magick "$tmpwallpaper" -gravity Center -extent 1:1 "$squarewallpaper"
cp "$squarewallpaper" "$generatedversions"/square-"$wallpaperfilename".png
