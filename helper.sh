is_installed() {
  package="$1"
  check="$(paru -Qs --color always "${package}" | grep "local" | grep "${package} ")"
  if [ -n "${check}" ]; then
    echo 0
    return #true
  fi
  echo 1
  return #false
}

install_packages() {
  toInstall=()
  for pkg; do
    if [[ $(is_installed "${pkg}") == 0 ]]; then
      echo ":: ${pkg} is already installed."
      continue
    fi
    toInstall+=("${pkg}")
  done
  if [[ "${toInstall[*]}" == "" ]]; then
    return
  fi
  printf "Package not installed:\n%s\n" "${toInstall[@]}"
  paru --noconfirm -S "${toInstall[@]}"
}

install_paru() {
  echo "::Installing paru..."
  sudo pacman -S --needed --noconfirm base-devel git

  if [ ! -d "$HOME"/Downloads ]; then
    mkdir "$HOME"/Downloads
  fi

  SCRIPT=$(realpath "$0")
  temp_path=$(dirname "$SCRIPT")
  git clone https://aur.archlinux.org/paru.git "$HOME"/Downloads/paru
  cd "$HOME"/Downloads/paru || exit
  makepkg --noconfirm -si
  cd "$temp_path" || exit
  echo "::paru has been installed successfully."
}

install_grub_btrfs() {
  echo "::Installing grub-btrfs..."
  sudo sed -i "s/\/.snapshots/-t/" /usr/lib/systemd/system/grub-btrfsd.service
  sudo systemctl start grub-btrfsd.service --now
  echo "::grub-btrfs has been installed successfully."
}

install_pnpm() {
  echo "::Installing pnpm..."
  sudo npm install -g pnpm
  pnpm self-update
  pnpm add -g commitizen cz-emoji-conventional vercel @bitwarden/cli
}

install_fnm() {
  curl -fsSL https://fnm.vercel.app/install | bash
  fnm use latest
}

install_pyenv() {
  curl https://pyenv.run | bash
}

create_snapshot() {
  echo "Creating snapshot..."
  sudo timeshift --create --comments "$1"
}

remove_package() {
  echo "Removing $1..."
  paru --noconfirm -Rsn "$1"
}

change_shell() {
  echo "Changing shell to zsh..."
  chsh -s "$(which zsh)"
}

setup_ufw() {
  install_packages "ufw"
  sudo ufw disable
  sudo ufw limit 22/tcp
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw enable
  sudo systemctl enable ufw --now
  echo "::UFW has been setup successfully."
}

remove_existing_config() {
  local dot_folder="dotfiles"
  # Check home
  files=$(ls -aAF "$HOME"/$dot_folder)
  for f in $files; do
    if [[ ! "$f" == *"/" ]] && [ -f "$f" ] && [[ -f "$HOME/$f" ]]; then
      echo ":: Deleting $HOME/$f"
      rm "$HOME"/"$f"
    fi
  done

  # Check .config
  files=$(ls -aAF "$HOME"/$dot_folder/.config)
  for f in $files; do
    if [[ -d "$HOME/.config/$f" ]]; then
      echo ":: Deleting Directory $HOME/.config/$f"
      rm -rf "$HOME/.config/$f"
    fi
    if [[ -f "$HOME/.config/$f" ]]; then
      echo ":: Deleting File $HOME/.config/$f"
      rm "$HOME/.config/$f"
    fi
  done

  # Other directories
  # .local/bin
  if [ -d "$HOME/.local" ]; then
    echo ":: Deleting $HOME/.local/bin"
    rm -rf "$HOME/.local/bin"
  fi
}

install_oh_my_zsh() {
  echo "::Installing Oh My Zsh..."
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ":: Installing oh-my-zsh"
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo ":: oh-my-zsh already installed"
  fi

  # Installing zsh-autosuggestions
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo ":: Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  else
    echo ":: zsh-autosuggestions already installed"
  fi

  # Installing zsh-syntax-highlighting
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo ":: Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
  else
    echo ":: zsh-syntax-highlighting already installed"
  fi

  # Installing fast-syntax-highlighting
  if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting" ]; then
    echo ":: Installing fast-syntax-highlighting"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fast-syntax-highlighting
  else
    echo ":: fast-syntax-highlighting already installed"
  fi
}

stow_dotfiles() {
  remove_existing_config
  echo "::Stowing config..."
  stow -t ~ -d ~/dotfiles/ .
}

install_wallpaper() {
  echo "::Installing wallpaper..."
  mkdir "$HOME"/wallpaper
  cd "$HOME"/wallpaper || exit
  git clone https://github.com/mylinuxforwork/wallpaper.git
  rm .git LICENSE README.md
}

cleanup() {
  paru -Scc
}
