import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import "../services" as QsServices

PanelWindow {
    id: root

    anchors {
        top: true
    }
    implicitWidth: 100
    implicitHeight: 25
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    visible: content.opacity > 0

    property bool userOpen: false
    property bool size: false
    property bool toggle: false

    // Reloj nativo de Quickshell integrado directamente
    SystemClock {
        id: systemClock
        precision: SystemClock.Minutes
    }

    // Estado de batería baja
    readonly property bool isLowBattery: QsServices.Battery.charge < 16 && !QsServices.Battery.charging

    // Cambia el tamaño y el sonido instantáneamente al entrar/salir de alerta
    onIsLowBatteryChanged: {
        if (isLowBattery) {
            root.size = true;
            sound.running = true;
        } else {
            root.size = root.userOpen;
            sound.running = false;
        }
    }

    GlobalShortcut {
        name: "togglePanel" // Solo defines el identificador del atajo

        onPressed: {
            root.userOpen = !root.userOpen;
            if (!root.isLowBattery) {
                root.size = root.userOpen;
            }
        }
    }

    Process {
        id: sound
        command: ["mpv", "--loop=inf", "--force-window=no", "/home/miguel/Downloads/copi/wale.m4a"]
        stdout: StdioCollector {
            onStreamFinished: {}
        }
    }

    Rectangle {
        id: content
        anchors.fill: parent
        color: QsServices.Colors.background
        border.pixelAligned: true
        border.color: QsServices.Colors.color4
        bottomLeftRadius: 15
        bottomRightRadius: 15

        opacity: root.size ? 1.0 : 0.0
        scale: root.size ? 1.0 : 0.0
        transformOrigin: Item.Top

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }

        Text {
            id: clock
            anchors.centerIn: parent
            color: QsServices.Colors.color6

            // Formateo directo con Qt.formatDateTime usando la fecha del SystemClock nativo
            text: root.isLowBattery ? QsServices.Battery.charge + "%" : (root.toggle ? QsServices.Battery.charge + "%" : Qt.formatDateTime(systemClock.date, "hh:mm AP"))
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.toggle = !root.toggle;
            }
        }
    }
}
