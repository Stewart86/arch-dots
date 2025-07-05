#!/bin/bash

clear
aur_helper="paru"
figlet -f smslant "Auto Update"
echo

_isInstalledAUR() {
    package="$1"
    check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

_is_safe_package() {
    local package="$1"
    
    # Critical packages to exclude from auto-update
    local critical_packages=(
        "linux"
        "linux-headers"
        "linux-lts"
        "linux-zen"
        "linux-hardened"
        "systemd"
        "glibc"
        "gcc"
        "gcc-libs"
        "binutils"
        "coreutils"
        "util-linux"
        "nvidia"
        "nvidia-dkms"
        "nvidia-lts"
        "nvidia-utils"
        "mesa"
        "xf86-video-"
        "vulkan-"
        "lib32-nvidia"
        "lib32-mesa"
        "grub"
        "efibootmgr"
        "mkinitcpio"
        "udev"
        "dbus"
        "polkit"
        "sudo"
        "shadow"
        "filesystem"
        "glib2"
        "gtk3"
        "gtk4"
        "qt5-base"
        "qt6-base"
        "xorg-server"
        "wayland"
        "pipewire"
        "wireplumber"
        "pulseaudio"
        "alsa-lib"
        "networkmanager"
        "dhcpcd"
        "openssh"
        "openssl"
        "ca-certificates"
        "archlinux-keyring"
        "pacman"
        "paru"
        "yay"
    )
    
    # Check if package matches any critical package pattern
    for critical in "${critical_packages[@]}"; do
        if [[ "$package" == *"$critical"* ]]; then
            return 1 # Not safe
        fi
    done
    
    return 0 # Safe
}

_get_safe_updates() {
    # Get list of packages that can be updated
    local updates=$($aur_helper -Qu 2>/dev/null)
    local safe_updates=()
    local excluded_updates=()
    
    if [ -z "$updates" ]; then
        return 0
    fi
    
    # Filter out critical packages
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            package=$(echo "$line" | awk '{print $1}')
            if _is_safe_package "$package"; then
                safe_updates+=("$package")
            else
                excluded_updates+=("$package")
            fi
        fi
    done <<< "$updates"
    
    # Store safe updates for later use
    echo "${safe_updates[@]}"
}

_show_update_summary() {
    echo ":: Checking for safe package updates..."
    
    # Get list of packages that can be updated
    local updates=$($aur_helper -Qu 2>/dev/null)
    local safe_updates=()
    local excluded_updates=()
    
    if [ -z "$updates" ]; then
        echo ":: No system package updates available"
        return 0
    fi
    
    # Filter out critical packages
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            package=$(echo "$line" | awk '{print $1}')
            if _is_safe_package "$package"; then
                safe_updates+=("$package")
            else
                excluded_updates+=("$package")
            fi
        fi
    done <<< "$updates"
    
    # Show what will be updated and what's excluded
    if [ ${#safe_updates[@]} -gt 0 ]; then
        echo ":: Safe packages to update (${#safe_updates[@]}):"
        printf "   %s\n" "${safe_updates[@]}"
    fi
    
    if [ ${#excluded_updates[@]} -gt 0 ]; then
        echo ":: Critical packages excluded from auto-update (${#excluded_updates[@]}):"
        printf "   %s\n" "${excluded_updates[@]}"
        echo ":: Run installupdates.sh manually to update these packages"
    fi
    
    echo
}

# ------------------------------------------------------
# Auto Update Process
# ------------------------------------------------------

echo ":: Starting automated update process..."
echo ":: $(date)"
echo

# Show update summary first
_show_update_summary

# Get safe updates for processing
safe_updates_list=($(_get_safe_updates))

# Create snapshot before updates
if [[ $(_isInstalledAUR "timeshift") == "0" ]]; then
    echo ":: Creating pre-update snapshot..."
    
    if [ ${#safe_updates_list[@]} -gt 0 ]; then
        # Create brief comment with first few package names
        comment_packages=""
        for i in "${safe_updates_list[@]:0:5}"; do
            if [ -z "$comment_packages" ]; then
                comment_packages="$i"
            else
                comment_packages="$comment_packages, $i"
            fi
        done
        
        if [ ${#safe_updates_list[@]} -gt 5 ]; then
            comment_packages="$comment_packages, ..."
        fi
        
        snapshot_comment="Auto-update: ${#safe_updates_list[@]} packages ($comment_packages)"
        sudo timeshift --create --comments "$snapshot_comment"
        echo ":: Snapshot created: $snapshot_comment"
    else
        echo ":: No safe updates available, skipping snapshot"
    fi
    echo
fi

# Update system packages (only safe ones)
if [ ${#safe_updates_list[@]} -gt 0 ]; then
    echo ":: Updating safe system packages..."
    $aur_helper --skipreview -S --noconfirm "${safe_updates_list[@]}"
else
    echo ":: No safe system packages to update"
fi

# Update other package managers
if _command_exists flatpak; then
    echo ":: Updating Flatpak packages..."
    flatpak upgrade -y
fi

if _command_exists pipx; then
    echo ":: Updating pipx packages..."
    pipx upgrade-all
fi

if _command_exists uv; then
    echo ":: Updating uv tools..."
    uv tool upgrade --all
fi

if _command_exists npm; then
    echo ":: Updating npm packages..."
    sudo npm update -g
fi

if _command_exists pnpm; then
    echo ":: Updating pnpm..."
    if _command_exists corepack; then
        corepack prepare pnpm@latest --activate
    else
        pnpm self-update
    fi
    pnpm -g update
fi

if _command_exists bun; then
    echo ":: Updating bun..."
    bun -g update --latest
fi

if _command_exists cargo; then
    echo ":: Updating cargo packages..."
    cargo install-update -a
fi

if _command_exists gem; then
    echo ":: Updating gem packages..."
    gem update --system
    gem update
fi

if _command_exists pyenv; then
    echo ":: Updating pyenv..."
    pyenv update
fi

if _command_exists fnm; then
    echo ":: Updating fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
fi

echo
echo ":: Auto-update complete at $(date)"
echo
echo ":: Summary:"
echo "   - Safe system packages updated: ${#safe_updates_list[@]}"
echo "   - Critical packages excluded (run installupdates.sh manually for these)"
echo "   - Other package managers updated"
echo
echo ":: Console will remain open for your review"
echo ":: Press Ctrl+C or close terminal when done"
echo

# Cleanup old snapshots
if [[ $(_isInstalledAUR "timeshift") == "0" ]]; then
    ~/.local/bin/cleanup_timeshift.sh
fi

# Keep terminal open indefinitely
while true; do
    sleep 1
done