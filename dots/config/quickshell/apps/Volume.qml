import Quickshell
import QtQuick
import "../services" as QsServices

PanelWindow {
    id: root

    anchors {
        right: true
        bottom: true
    }

    // Dimensiones fijas para evitar re-layouts de Wayland
    implicitWidth: 25
    implicitHeight: 250
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    margins {
        right: 12
        bottom: 12
    }

    // Control de visibilidad fluido
    visible: content.opacity > 0

    // Timer local para ocultar el OSD 3 segundos después de que el volumen deje de cambiar
    Timer {
        id: hideTimer
        interval: 3000
        repeat: false
        onTriggered: content.active = false
    }

    // Función para mostrar el OSD y reiniciar el tiempo de espera
    function showOSD() {
        content.active = true;
        hideTimer.restart();
    }

    // Escuchar cambios de volumen o silencio (incluso desde atajos de teclado externos)
    Connections {
        target: QsServices.Audio

        // Ignorar el primer disparo al cargar la app
        property bool initialized: false

        function onVolumeChanged() {
            if (initialized)
                root.showOSD();
            else
                initialized = true;
        }

        function onMutedChanged() {
            if (initialized)
                root.showOSD();
            else
                initialized = true;
        }
    }

    Rectangle {
        id: content

        property bool active: false

        anchors.fill: parent
        color: QsServices.Colors.background
        border.pixelAligned: true
        border.color: QsServices.Colors.color4
        radius: 15

        // Transición fluida de aparición y desaparición
        opacity: active ? 1.0 : 0.0
        scale: active ? 1.0 : 0.0
        transformOrigin: Item.BottomRight

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

        // Barra de nivel de volumen
        Rectangle {
            id: volumeBar
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            // Binding reactivo para el color
            color: QsServices.Audio.muted ? QsServices.Colors.color2 : QsServices.Colors.color5
            height: parent.height * Math.min(1.0, QsServices.Audio.volume)
            radius: parent.radius

            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Porcentaje de texto
        Text {
            text: QsServices.Audio.percentage
            color: "white"
            font.pixelSize: 10
            anchors {
                top: parent.top
                topMargin: 8
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -1
            }
        }

        // Ícono reactivo directo
        Text {
            id: icon
            text: QsServices.Audio.muted ? "󿾘" : ""
            color: "white"
            anchors {
                bottom: parent.bottom
                bottomMargin: 8
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
