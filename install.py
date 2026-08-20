import subprocess
import os


user = os.system("echo $USER")

# Install pacman apps

pacman_apps = ["cmake",
               "base-devel",
               "awww",
               "fastfetch",
               "gpu-screen-recorder",
               "impala",
               "loupe",
               "mpv",
               "nemo",
               "neovim",
               "firefox",
               "pavucontrol",
               "peazip",
               "quickshell",
               "qt6-tools",
               "qt6-virtualkeyboard",
               "wl-clipboard",
               "hyprlauncher",
               "npm",
               "unzip",
               "layer-shell-qt",
               "nlohmann-json",
               "wine",
               "xorg-xev",
               "zsh"]

subprocess.run(["sudo", "pacman", "-S"] + pacman_apps)

# Install yay and yay apps

#install yay
subprocess.run(["git", "clone", "https://aur.archlinux.org/yay.git"])
os.system("cd yay && makepkg -si")

#install apps

yay_apps = ["python-pywal16"]

subprocess.run(["yay", "-S"] + yay_apps)

# move dots
subprocess.run(["mv", "--backup", "./dots/config/*", "~/.config"])

# conf sddm dinamic theme

subprocess.run(["sudo", "mv", "./dots/dinamic", "/usr/share/sddm/themes/"])
subprocess.run(["sudo", "chown", "-R", f"{user}:{user}", "/usr/share/sddm/themes/dinamic/Backgrounds/"])
subprocess.run(["sudo", "touch", "/etc/sddm.conf"])
theme = "[Theme]\nCurrent=dinamic\n"
subprocess.run(
    ["sudo", "tee", "/etc/sddm.conf"],
    input=theme,
    text=True,
    check=True
)

os.system("chsh -s $(which zsh)")

subprocess.run(["hyprpm", "update"])
subprocess.run(["hyprpm", "add", "https://github.com/gfhdhytghd/HyprCapture"])
subprocess.run(["hyprpm", "enable", "hyprcapture"])
subprocess.run(["hyprpm", "reload"])

# reload wall and colors

subprocess.run(["mv", "--backup", "./dots/Images", "~/"])
subprocess.run(["python3", "~/.config/apps/wallchange/wallchange.py", "-p", "01.jpg"])

print("Instalacion terminada se recomienda que reinicie el sistema")
