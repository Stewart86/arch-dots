#!/bin/bash

clear
figlet -f smslant "Timeshift"

_isInstalledAUR() {
    package="$1"
    check="$(paru -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

timeshift_installed=$(_isInstalledAUR "timeshift")
grubbtrfs_installed=$(_isInstalledAUR "grub-btrfs")

if [[ $timeshift_installed == "0" ]]; then
    echo ":: Timeshift is already installed"
else
    if gum confirm "DO YOU WANT TO INSTALL Timeshift now?"; then
        paru -S timeshift
    fi
fi
if [[ -d /boot/grub ]] && [[ $grubbtrfs_installed == "0" ]]; then
    echo ":: grub-btrfs is already installed"
else
    echo ":: grub-btrfs is required to select a snapshot on grub bootloader."
    if gum confirm "DO YOU WANT TO INSTALL grub-btrfs now?"; then
        paru -S grub-btrfs
    fi
fi
sleep 3
