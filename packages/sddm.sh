export packages=(
  "sddm"
  "qt5-graphicaleffects"
  "qt5-quickcontrols2"
  "qt5-svg"
)

enable_sddm() {
  sudo systemctl enable sddm
}
