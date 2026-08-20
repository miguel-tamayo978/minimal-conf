pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property real brightness: 0.5
  readonly property real level: brightness
  readonly property int percentage: Math.round(brightness * 100)

  property string _backlightDevice: ""
  readonly property string backlightPath: _backlightDevice !== "" ? `/sys/class/backlight/${_backlightDevice}/brightness` : ""
  readonly property string maxBrightnessPath: _backlightDevice !== "" ? `/sys/class/backlight/${_backlightDevice}/max_brightness` : ""

  property int currentValue: 0
  property int maxValue: 255

  function updateBrightness(): void {
    if (backlightPath !== "") {
      brightnessProcess.running = true;
    }
  }

  Component.onCompleted: {
    detectProc.running = true;
  }

  // Escucha eventos de hardware de brillo (reacción instantánea ante teclas multimedia)
  Process {
    running: root._backlightDevice !== ""
    command: ["udevadm", "monitor", "--subsystem-match=backlight"]
    stdout: SplitParser {
      onRead: data => {
        root.updateBrightness();
      }
    }
  }

  // Detección automática del dispositivo
  Process {
    id: detectProc
    command: ["sh", "-c", "ls -1 /sys/class/backlight 2>/dev/null | head -n 1"]
    stdout: SplitParser {
      onRead: data => {
        const dev = data.trim();
        if (dev.length > 0) {
          root._backlightDevice = dev;
          maxBrightnessProcess.command = ["cat", root.maxBrightnessPath];
          maxBrightnessProcess.running = true;
          root.updateBrightness();
        }
      }
    }
  }

  // Lectura de Max Brightness
  Process {
    id: maxBrightnessProcess
    stdout: SplitParser {
      onRead: data => {
        const val = parseInt(data.trim());
        if (!isNaN(val) && val > 0)
        root.maxValue = val;
      }
    }
  }

  // Lectura del valor actual de brillo
  Process {
    id: brightnessProcess
    command: ["cat", root.backlightPath]
    stdout: SplitParser {
      onRead: data => {
        const val = parseInt(data.trim());
        if (!isNaN(val)) {
          root.currentValue = val;
          root.brightness = root.maxValue > 0 ? Math.min(1.0, Math.max(0.0, val / root.maxValue)) : 0;
        }
      }
    }
  }

  // Funciones de control de brillo
  function setBrightness(value) {
    const percent = Math.round(Math.max(0, Math.min(1, value)) * 100);
    runCmd(["brightnessctl", "set", `${percent}%`]);
  }

  function increaseBrightness() {
    setBrightness(brightness + 0.05);
  }
  function decreaseBrightness() {
    setBrightness(brightness - 0.05);
  }

  function runCmd(cmdArray) {
    actionProc.command = cmdArray;
    actionProc.running = true;
  }

  Process {
    id: actionProc
  }
}
