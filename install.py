import subprocess
import os


user = input("Escribe tu usuario > ")

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
               "pavucontrol",
               "peazip",
               "quickshell",
               "qt6-tools",
               "qt6-virtualkeyboard",
               "wf-recorder",
               "wine",
               "xorg-xev",
               "zsh"]

subprocess.run(["sudo", "pacman", "-S"] + pacman_apps)

# Install yay and yay apps

#install yay
subprocess.run(["git", "clone", "https://aur.archlinux.org/yay.git"])
subprocess.run(["cd", "yay", "&&", "makepkg -si"])

#install apps

yay_apps = ["python-pywal16"]

subprocess.run(["yay", "-S"] + yay_apps)

# move dots
subprocess.run(["mv", "./dots/config/*", "~/.config"])

# conf sddm dinamic theme

subprocess.run(["sudo", "mv", "./dots/dinamic", "/usr/share/sddm/themes/"])
subprocess.run(["sudo", "chown", "-R", f"{user}:{user}", "/usr/share/sddm/themes/dinamic/Backgrounds/"])
subprocess.run(["sudo", "touch", "/etc/sddm.conf"])
theme = "[Theme]\nCurrent=maya\n"
subprocess.run(
    ["sudo", "tee", "/etc/sddm.conf"],
    input=theme,
    text=True,
    check=True
)

os.system("chsh -s $(which zsh)")

print("Instalacion terminada se recomienda que reinicie el sistema")
