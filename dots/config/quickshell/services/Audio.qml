pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property bool ready: false
  property bool muted: false
  property real volume: 0
  readonly property int percentage: Math.round(volume * 100)

  property bool sourceReady: false
  property bool sourceMuted: false
  property real sourceVolume: 0
  readonly property int sourcePercentage: Math.round(sourceVolume * 100)

  // Actualiza el volumen ejecutando wpctl solo cuando PipeWire notifica un cambio
  function updateSink(): void {
    getSink.running = true;
  }

  function updateSource(): void {
    getSource.running = true;
  }

  Component.onCompleted: {
    updateSink();
    updateSource();
  }

  // Suscripción de eventos en tiempo real (reacción instantánea a teclas multimedia)
  Process {
    running: true
    command: ["pactl", "subscribe"]
    stdout: SplitParser {
      onRead: data => {
        if (data.includes("change")) {
          if (data.includes("sink"))
          root.updateSink();
          if (data.includes("source"))
          root.updateSource();
        }
      }
    }
  }

  // Obtener datos del SINK (Salida de audio)
  Process {
    id: getSink
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        const s = text.trim();
        const m = s.match(/Volume:\s*([0-9.]+)/);
        if (m) {
          const v = parseFloat(m[1]);
          if (!isNaN(v)) {
            root.ready = true;
            root.volume = Math.max(0, Math.min(1.5, v));
          }
        }
        root.muted = s.includes("[MUTED]");
      }
    }
  }

  // Obtener datos del SOURCE (Micrófono)
  Process {
    id: getSource
    command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
    stdout: StdioCollector {
      onStreamFinished: {
        const s = text.trim();
        const m = s.match(/Volume:\s*([0-9.]+)/);
        if (m) {
          const v = parseFloat(m[1]);
          if (!isNaN(v)) {
            root.sourceReady = true;
            root.sourceVolume = Math.max(0, Math.min(1.5, v));
          }
        }
        root.sourceMuted = s.includes("[MUTED]");
      }
    }
  }

  // Métodos para cambiar volumen
  function setVolume(newVolume) {
    setMute(false);
    runCmd(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", Math.max(0, Math.min(1.5, newVolume)).toFixed(3)]);
  }

  function increaseVolume() {
    setVolume(volume + 0.05);
  }
  function decreaseVolume() {
    setVolume(volume - 0.05);
  }

  function setMute(m) {
    runCmd(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", m ? "1" : "0"]);
  }

  function toggleMute() {
    runCmd(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]);
  }

  function setSourceVolume(newVolume) {
    setSourceMute(false);
    runCmd(["wpctl", "set-volume", "@DEFAULT_AUDIO_SOURCE@", Math.max(0, Math.min(1.5, newVolume)).toFixed(3)]);
  }

  function setSourceMute(m) {
    runCmd(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", m ? "1" : "0"]);
  }

  function toggleSourceMute() {
    runCmd(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]);
  }

  // Helper para reutilizar un proceso sin instanciar múltiples nodos
  function runCmd(cmdArray) {
    actionProc.command = cmdArray;
    actionProc.running = true;
  }

  Process {
    id: actionProc
  }
}
