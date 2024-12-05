export EDITOR=nvim
export PATH="/usr/lib/ccache/bin/:$PATH"

POSH=agnoster

# -----------------------------------------------------
# Prompt
# -----------------------------------------------------
eval "$(oh-my-posh init bash --config $HOME/.config/ohmyposh/zen.toml)"

# -----------------------------------------------------
# Pywal
# -----------------------------------------------------
cat ~/.cache/wal/sequences

if [[ $(tty) == *"pts"* ]]; then
    fastfetch --config examples/13
else
    echo
    echo "Start Hyprland with command Hyprland"
fi
