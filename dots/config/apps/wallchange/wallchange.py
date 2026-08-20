import os
from pathlib import Path
import sys
import random


dir = Path("/home/miguel/Images/Wallpapers/")

def get_actual():
    temp = os.popen("awww query -a | grep -oP 'image: \\K.*'").read()
    return temp[temp.rfind("/") + 1:].rstrip()

actual = get_actual()

def get_walls(directory: Path):
    walls = {}
    i = 1
    for file in sorted(directory.glob("*")):
        if file.is_file() and file.name.endswith((".gif", ".jpg", ".png")):
            walls[file.name] = i
            i += 1
    return walls

walls = get_walls(dir)

def value_find(value):
    global walls
    for clave, valor in walls.items():
        if valor == value:
            return clave

def update(path, angle):
    os.system(f"awww img {path} -t wave --transition-duration 2 --transition-angle {angle} --transition-bezier .43,1.19,1,.4 --transition-fps 60")
    os.system(f"wal -n --cols16  -i {path}")
    os.system("hyprctl reload")
    os.system(f"cp {path} /usr/share/sddm/themes/dinamic/Backgrounds/wall")
    

def next(name) -> None:
    global walls
    next_value = (walls.get(name, 1) + 1) if walls.get(name, 1) < len(walls) else 1
    next_img = value_find(next_value)
    path = f"/home/miguel/Images/Wallpapers/{next_img}"
    update(path, 90)


def prev(name) -> None:
    global walls
    next_value = (walls.get(name, 1) - 1) if walls.get(name, 1) > 1 else len(walls)
    next_img = value_find(next_value)
    path = f"/home/miguel/Images/Wallpapers/{next_img}"
    update(path, 270)

def select(name) -> None:
    path = f"/home/miguel/Images/Wallpapers/{name}"
    update(path, random.randint(0,360))

def init():
    global actual
    if len(sys.argv) < 2:
        print("next = +1 en la lista\nprev = -1 en la lista")
        sys.exit()
    if sys.argv[1].lower() == "next":
        next(actual)
    elif sys.argv[1].lower() == "prev":
        prev(actual)
    elif sys.argv[1].lower() == "-p":
        select(sys.argv[2])
    else:
        print("next = +1 en la lista\nprev = -1 en la lista")
if __name__ == "__main__":
    init()

