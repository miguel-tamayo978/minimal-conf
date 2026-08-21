#!/usr/bin/env bash

set -e

pacman_apps=(
  "cmake"
  "base-devel"
  "awww"
  "fastfetch"
  "gpu-screen-recorder"
  "impala"
  "loupe"
  "mpv"
  "nemo"
  "neovim"
  "firefox"
  "pavucontrol"
  "peazip"
  "quickshell"
  "qt6-tools"
  "qt6-virtualkeyboard"
  "wl-clipboard"
  "hyprlauncher"
  "npm"
  "unzip"
  "layer-shell-qt"
  "nlohmann-json"
  "wine"
  "xorg-xev"
  "zsh"
)

echo "Instalando paquetes de pacman..."
sudo pacman -S --needed "${pacman_apps[@]}"

if ! command -v yay &>/dev/null; then
  echo "Instalando yay..."
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

yay_apps=(
  "python-pywal16"
)

echo "Instalando paquetes de AUR..."
yay -S --needed "${yay_apps[@]}"

echo "Moviendo archivos de configuración..."
mkdir -p "$HOME/.config"
cp --backup=numbered ./dots/config/* "$HOME/.config/" 2>/dev/null || mv --backup ./dots/config/* "$HOME/.config/"

echo "Configurando SDDM..."
sudo mv ./dots/dinamic /usr/share/sddm/themes/
sudo chown -R "$USER_NAME:$USER_NAME" /usr/share/sddm/themes/dinamic/Backgrounds/

echo -e "[Theme]\nCurrent=dinamic" | sudo tee /etc/sddm.conf >/dev/null

echo "Cambiando shell predeterminada a ZSH..."
chsh -s "$(which zsh)"

echo "Configurando hyprpm..."
hyprpm update
hyprpm add https://github.com/gfhdhytghd/HyprCapture
hyprpm enable hyprcapture
hyprpm reload

echo "Configurando fondos de pantalla..."
mv --backup ./dots/Images "$HOME/"
python3 "$HOME/.config/apps/wallchange/wallchange.py" -p "01.jpg"

echo "Instalación terminada, se recomienda reiniciar el sistema."
