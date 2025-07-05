# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an Arch Linux dotfiles repository for a Hyprland-based desktop environment. The setup uses GNU Stow for symlink management and includes comprehensive configurations for a modern Wayland desktop setup.

## Installation Commands

Initial setup (run from any location):
```bash
./setup.sh  # Clones repo and starts installation
```

Full system installation (run from dotfiles directory):
```bash
./install.sh  # Complete system setup with all packages
```

Apply dotfiles only:
```bash
stow -t ~ -d ~/dotfiles/ .  # Symlink configs to home directory
```

Remove existing configs before stowing:
```bash
source ./helper.sh && remove_existing_config && stow_dotfiles
```

## Package Management

Install specific package groups:
```bash
source ./packages/essential.sh && install_packages "${packages[@]}"
source ./packages/hyprland.sh && install_packages "${packages[@]}"
source ./packages/gui.sh && install_packages "${packages[@]}"
```

The helper.sh provides utility functions:
- `install_packages()` - Install packages with paru, skipping already installed
- `is_installed()` - Check if package is installed
- `create_snapshot()` - Create timeshift snapshots

## Architecture

### Configuration Structure
- `.config/` - Main application configurations managed by stow
- `.local/bin/` - Custom scripts and utilities
- `packages/` - Package lists organized by category (essential, hyprland, gui, fonts, tools)
- `sddm-sequoia/` - Custom SDDM theme

### Key Components
- **Hyprland**: Wayland compositor with extensive configuration in `.config/hypr/`
- **Waybar**: Status bar configuration in `.config/waybar/`
- **Kitty**: Terminal emulator config
- **Neovim**: Editor configuration with AstroNvim
- **Zsh**: Shell with Oh My Zsh and custom configurations in `.config/zshrc/`

### Stow Management
The repository uses GNU Stow to manage dotfiles. All configs are structured to be stowed from the repository root to the home directory. The `stow_dotfiles()` function handles removal of existing configs before creating symlinks.

### System Integration
- SDDM display manager with custom theme
- UFW firewall with predefined rules
- Timeshift snapshots at key installation points
- Node.js via fnm, Python via pyenv
- Package management via paru (AUR helper)