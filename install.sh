#!/usr/bin/env bash

# Salir si ocurre un error
set -e

# Guardar el usuario actual
USER_NAME="$USER"

# Lista de paquetes de pacman (añadí curl por si acaso no está)
pacman_apps=(
  "cmake"
  "base-devel"
  "curl"
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

# Instalar aplicaciones con pacman
echo "Instalando paquetes de pacman..."
sudo pacman -S --needed "${pacman_apps[@]}"

# Instalar yay si no está instalado
if ! command -v yay &>/dev/null; then
  echo "Instalando yay..."
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
fi

# Instalar paquetes AUR con yay
yay_apps=(
  "python-pywal16"
)

echo "Instalando paquetes de AUR..."
yay -S --needed "${yay_apps[@]}"

# Mover dotfiles
echo "Moviendo archivos de configuración..."
mkdir -p "$HOME/.config"
cp --backup=numbered ./dots/config/* "$HOME/.config/" 2>/dev/null || mv --backup ./dots/config/* "$HOME/.config/"

# Configurar el tema dinámico de SDDM
echo "Configurando SDDM..."
sudo mv ./dots/dinamic /usr/share/sddm/themes/
sudo chown -R "$USER_NAME:$USER_NAME" /usr/share/sddm/themes/dinamic/Backgrounds/

echo -e "[Theme]\nCurrent=dinamic" | sudo tee /etc/sddm.conf >/dev/null

# Cambiar shell por defecto a zsh
echo "Cambiando shell predeterminada a ZSH..."
chsh -s "$(which zsh)"

# ---------------------------------------------------------
# INSTALACIÓN DE OH MY ZSH Y PLUGINS
# ---------------------------------------------------------
echo "Instalando Oh My Zsh y plugins..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # Instalación desatendida de Oh My Zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Instalar zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Instalar zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Habilitar los plugins en el .zshrc
if [ -f "$HOME/.zshrc" ]; then
  sed -i 's/^plugins=(.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"
fi
# ---------------------------------------------------------

# Configurar plugins de Hyprland
echo "Configurando hyprpm..."
hyprpm update
hyprpm add https://github.com/gfhdhytghd/HyprCapture
hyprpm enable hyprcapture
hyprpm reload

# Mover imágenes y recargar fondo
echo "Configurando fondos de pantalla..."
mv --backup ./dots/Images "$HOME/"
python3 "$HOME/.config/apps/wallchange/wallchange.py" -p "01.jpg"

echo "Instalación terminada, se recomienda reiniciar el sistema."
