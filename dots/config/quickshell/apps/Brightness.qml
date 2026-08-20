import Quickshell
import QtQuick
import "../services" as QsServices

PanelWindow {
    id: root

    anchors {
        right: true
        top: true
    }

    // Dimensiones fijas para evitar re-layouts en Wayland
    implicitWidth: 25
    implicitHeight: 250
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    margins {
        right: 12
        top: 12
    }

    visible: content.opacity > 0

    // Oculta el OSD tras 3 segundos de inactividad
    Timer {
        id: hideTimer
        interval: 3000
        repeat: false
        onTriggered: content.active = false
    }

    function showOSD() {
        content.active = true;
        hideTimer.restart();
    }

    // Reactividad: Muestra el OSD solo cuando cambia la propiedad `brightness`
    Connections {
        target: QsServices.Brightness

        property bool initialized: false

        function onBrightnessChanged() {
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

        opacity: active ? 1.0 : 0.0
        scale: active ? 1.0 : 0.0
        transformOrigin: Item.TopRight

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

        // Barra de porcentaje de brillo
        Rectangle {
            id: brightnessBar
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            color: QsServices.Colors.color7
            height: parent.height * Math.min(1.0, QsServices.Brightness.brightness)
            radius: parent.radius

            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Porcentaje impreso en texto
        Text {
            text: QsServices.Brightness.percentage
            color: "white"
            font.pixelSize: 10
            anchors {
                top: parent.top
                topMargin: 8
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -1
            }
        }

        // Ícono
        Text {
            id: icon
            text: ""
            color: "white"
            anchors {
                bottom: parent.bottom
                bottomMargin: 8
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
