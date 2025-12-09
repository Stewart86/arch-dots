#!/bin/bash

clear
aur_helper="paru"
figlet -f smslant "Updates"
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

_needs_restart() {
    # Check if kernel was updated
    if [ -f /proc/version ]; then
        running_kernel=$(uname -r)
        installed_kernel=$(pacman -Q linux 2>/dev/null | awk '{print $2}' | sed 's/\.arch.*$//')
        if [ -n "$installed_kernel" ] && [[ "$running_kernel" != *"$installed_kernel"* ]]; then
            return 0
        fi
    fi

    # Check if critical packages need restart (only if they exist and were recently updated)
    if [ -f /var/log/pacman.log ]; then
        today=$(date +%Y-%m-%d)
        if grep "^\\[$today" /var/log/pacman.log | grep -q "\\(upgraded\\|installed\\) \\(systemd\\|linux\\|nvidia\\|mesa\\)"; then
            return 0
        fi
    fi

    return 1
}

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

if gum confirm "DO YOU WANT TO START THE UPDATE NOW?"; then
    echo
    echo ":: Update started."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Update canceled."
    exit
fi

if [[ $(_isInstalledAUR "timeshift") == "0" ]]; then
    echo
    if gum confirm "DO YOU WANT TO CREATE A SNAPSHOT?"; then
        echo
        c=$(gum input --placeholder "Enter a comment for the snapshot...")
        sudo timeshift --create --comments "$c"
        sudo timeshift --list
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo ":: DONE. Snapshot $c created!"
        echo
    elif [ $? -eq 130 ]; then
        echo ":: Snapshot skipped."
        exit 130
    else
        echo ":: Snapshot skipped."
    fi
    echo
fi

echo ":: Updating system packages..."
$aur_helper --skipreview -Syu --noconfirm

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
    npm update -g
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

notify-send "Update complete"
echo
echo ":: Update complete"
echo

if _needs_restart; then
    echo
    echo ":: System restart recommended due to kernel or critical service updates"
    if gum confirm "DO YOU WANT TO RESTART NOW?"; then
        echo ":: Restarting system..."
        systemctl reboot
    elif [ $? -eq 130 ]; then
        echo ":: Restart canceled (Ctrl+C pressed)"
        exit 130
    else
        echo ":: Restart skipped - please restart manually later"
        echo
        echo "Press [ENTER] to close."
        read -r
    fi
else
    echo
    echo "Press [ENTER] to close."
    read -r
fi
