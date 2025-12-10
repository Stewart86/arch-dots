#!/bin/bash
# Checks for updates across all package managers and outputs a total count
# Used by quickshell Updates service to show update notifications

_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

total=0

# Arch packages (pacman + AUR via checkupdates)
if _command_exists checkupdates; then
    pacman_count=$(checkupdates 2>/dev/null | wc -l)
    total=$((total + pacman_count))
fi

# AUR packages via paru
if _command_exists paru; then
    aur_count=$(paru -Qua 2>/dev/null | wc -l)
    total=$((total + aur_count))
fi

# Flatpak
if _command_exists flatpak; then
    flatpak_count=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
    total=$((total + flatpak_count))
fi

# pipx
if _command_exists pipx; then
    pipx_count=$(pipx list --short 2>/dev/null | while read -r pkg; do
        pipx runpip "$pkg" list --outdated 2>/dev/null
    done | wc -l)
    total=$((total + pipx_count))
fi

# npm global packages
if _command_exists npm; then
    npm_count=$(npm outdated -g --parseable 2>/dev/null | wc -l)
    total=$((total + npm_count))
fi

# cargo packages (if cargo-install-update is installed)
if _command_exists cargo-install-update; then
    cargo_count=$(cargo install-update -l 2>/dev/null | grep -c "Yes")
    total=$((total + cargo_count))
fi

echo "$total"
