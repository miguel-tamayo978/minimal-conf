pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property bool charging: true
  property int charge: 100

  Timer {
    interval: 2000 // Revisa cada 2s sin apenas impacto en CPU
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (!readBattery.running) {
        readBattery.running = true;
      }
    }
  }

  Process {
    id: readBattery
    // Lee los dos archivos del kernel de una sola pasada
    command: ["cat", "/sys/class/power_supply/BAT0/capacity", "/sys/class/power_supply/BAT0/status"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = text.trim().split("\n");
        if (lines.length >= 2) {
          const parsedCharge = parseInt(lines[0]);
          if (!isNaN(parsedCharge)) {
            root.charge = parsedCharge;
          }

          const status = lines[1].toLowerCase();
          root.charging = (status === "charging" || status === "full");
        }
      }
    }
  }
}
