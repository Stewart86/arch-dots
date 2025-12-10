# AGENTS.md

This file provides guidance to AI agents (Claude, Codex, etc.) when working with this repository.

## Repository Overview

This is an Arch Linux dotfiles repository for a Hyprland-based desktop environment using **end-4/dots-hyprland (illogical-impulse)** as the base configuration. The setup uses GNU Stow for symlink management.

## Desktop Environment Stack

- **Compositor**: Hyprland (Wayland)
- **Shell/Widgets**: Quickshell (illogical-impulse) - replaces waybar, rofi, dunst
- **Terminal**: Ghostty (primary), Kitty (fallback)
- **Browser**: Microsoft Edge (Flatpak)
- **Shell**: Zsh with Oh-My-Zsh
- **Prompt**: Oh My Posh
- **Editor**: Neovim (AstroNvim), Zed

## Key Configuration Locations

### Custom Overrides (version controlled)
These files override end-4 defaults and are safe to modify:

```
~/.config/hypr/custom/
├── env.conf          # Environment variables (TERMINAL, etc.)
├── execs.conf        # Autostart applications
├── general.conf      # General hyprland settings
├── keybinds.conf     # Custom keybindings
├── rules.conf        # Window rules
└── scripts/          # Custom scripts

~/.config/illogical-impulse/config.json  # Quickshell settings
```

### End-4 Managed (avoid direct edits)
These are managed by the end-4 update script:

```
~/.config/hypr/hyprland/    # Base hyprland config
~/.config/quickshell/       # Quickshell widgets
~/.config/cava/             # Audio visualizer
~/.config/fuzzel/           # Fallback launcher
~/.config/fontconfig/       # Font configuration
```

## Important Commands

```bash
# Apply dotfiles
stow -t ~ -d ~/dotfiles/ .

# Update end-4 dots
update-dots.sh

# Reload Hyprland
hyprctl reload

# Restart Quickshell
Ctrl + Super + R

# Show all keybinds
Super + /
```

## Custom Keybindings

The setup uses **Super (Windows key)** as the main modifier:

| Keybind | Action |
|---------|--------|
| `Super` | Overview/launcher |
| `Super + Return` | Terminal |
| `Super + Shift + Return` | Floating terminal |
| `Super + Q` | Close window |
| `Super + H/J/K/L` | Vim-style focus navigation |
| `Super + Shift + H/J/K/L` | Move window |
| `Super + Ctrl + H/J/K/L` | Resize window |
| `Super + Ctrl + B` | Toggle bar |
| `Super + /` | Keybind cheatsheet |
| `Super + V` | Clipboard history |
| `Super + .` | Emoji picker |

## Package Management

- **System packages**: paru (AUR helper)
- **Flatpak apps**: Edge, Discord, Slack, Telegram, ZapZap, Betterbird
- **Package lists**: See `packages/` directory

## File Structure

```
dotfiles/
├── .config/
│   ├── hypr/custom/       # Hyprland overrides
│   ├── illogical-impulse/ # Quickshell config
│   ├── ghostty/           # Terminal config
│   ├── nvim/              # Neovim (AstroNvim)
│   ├── zshrc/             # Zsh configuration
│   └── ...
├── .local/bin/            # Custom scripts
├── packages/              # Package lists
├── install.sh             # Full installation script
├── setup.sh               # Initial setup
└── helper.sh              # Utility functions
```

## Things to Avoid

1. **Don't edit files in `~/.config/hypr/hyprland/`** - Use custom overrides instead
2. **Don't symlink all of ~/.config** - Many dirs contain runtime state/secrets
3. **Don't use uwsm** - End-4 setup doesn't use it
4. **Don't install waybar/rofi/dunst** - Quickshell replaces these

## Updating

To update end-4 configuration:
```bash
update-dots.sh
```

This will:
1. Stash local changes in `~/.cache/dots-hyprland`
2. Pull latest from end-4 repo
3. Run the installer

Custom overrides in `~/.config/hypr/custom/` are preserved.
