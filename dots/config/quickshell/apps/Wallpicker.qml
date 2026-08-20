import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import "file:///home/miguel/.config/quickshell/services" as QsServices

PanelWindow {
    id: root

    anchors {
        bottom: true
    }

    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 1000
    implicitHeight: 210
    color: "transparent"
    focusable: true

    readonly property string userHome: Quickshell.env("HOME")

    function closeApp() {
        bgContainer.active = false;
        closeTimer.start();
    }

    Timer {
        id: closeTimer
        interval: 150
        repeat: false
        onTriggered: Qt.quit()
    }

    Process {
        id: awwwProcess
        command: ["awww", "query"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                if (!data.includes("currently displaying:"))
                    return;

                let fullPath = data.split("image: ")[1]?.trim();
                if (!fullPath)
                    return;

                let fileName = fullPath.substring(fullPath.lastIndexOf("/") + 1);

                for (var i = 0; i < folderModel.count; i++) {
                    if (folderModel.get(i, "fileName") === fileName) {
                        carrusel.currentIndex = i;

                        if (!carrusel.initialLoaded) {
                            carrusel.positionViewAtIndex(i, ListView.Center);
                            carrusel.initialLoaded = true;
                        }
                        break;
                    }
                }
            }
        }
    }

    Item {
        id: rootContainer
        anchors.fill: parent
        clip: true

        Rectangle {
            id: bgContainer
            property bool active: false

            width: parent.width
            height: 210
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            // Control de visibilidad idéntico al primer script
            visible: opacity > 0
            opacity: active ? 1.0 : 0.0
            scale: active ? 1.0 : 0.0
            transformOrigin: Item.Bottom // Crece y se contrae desde la parte inferior

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            antialiasing: true
            topLeftRadius: 15
            topRightRadius: 15
            border.pixelAligned: true
            border.color: QsServices.Colors.color4
            color: QsServices.Colors.background
            clip: true

            FolderListModel {
                id: folderModel
                folder: "file://" + root.userHome + "/Images/Wallpapers/"
                nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp"]
                showDirs: false
                sortField: FolderListModel.Name

                onStatusChanged: {
                    if (status === FolderListModel.Ready && count > 0) {
                        carrusel.forceActiveFocus();
                        awwwProcess.running = true;
                    }
                }
            }

            Rectangle {
                id: carruselContainer
                anchors.centerIn: parent
                width: parent.width - 24
                height: parent.height - 30
                color: "transparent"
                clip: true

                ListView {
                    id: carrusel
                    anchors.fill: parent
                    orientation: ListView.Horizontal
                    spacing: 16
                    model: folderModel
                    currentIndex: 0
                    focus: true
                    visible: folderModel.count > 0

                    property bool initialLoaded: false
                    property real cardWidth: 310
                    property real cardHeight: 174.375

                    property int loadedImagesCount: 0
                    property bool appReady: false

                    highlightRangeMode: ListView.StrictlyEnforceRange
                    preferredHighlightBegin: (width - cardWidth) / 2
                    preferredHighlightEnd: (width + cardWidth) / 2
                    highlightMoveDuration: 250

                    function applyWallpaper() {
                        let selectedFile = folderModel.get(carrusel.currentIndex, "fileName");
                        if (selectedFile) {
                            let scriptPath = root.userHome + "/.config/apps/wallchange/wallchange.py";
                            let cmd = "python3 " + scriptPath + " -p " + selectedFile;
                            Quickshell.execDetached(["bash", "-c", cmd]);
                            root.closeApp();
                        }
                    }

                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Left && currentIndex > 0) {
                            currentIndex--;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Right && currentIndex < folderModel.count - 1) {
                            currentIndex++;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
                            applyWallpaper();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            root.closeApp();
                            event.accepted = true;
                        }
                    }

                    delegate: Item {
                        id: delegateRoot
                        width: carrusel.cardWidth
                        height: carrusel.cardHeight
                        y: (carrusel.height - height) / 2

                        readonly property bool isCurrent: ListView.isCurrentItem

                        scale: isCurrent ? 1.05 : 0.88
                        opacity: isCurrent ? 1.0 : 0.5

                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                            }
                        }

                        Rectangle {
                            id: card
                            anchors.fill: parent
                            radius: 12
                            color: QsServices.Colors.background
                            clip: true
                            border.color: isCurrent ? QsServices.Colors.color4 : "transparent"
                            border.width: isCurrent ? 2 : 0

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Image {
                                id: wallpaperImg
                                anchors.fill: parent
                                source: model.fileUrl
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                smooth: true
                                cache: true
                                sourceSize.width: 600

                                onStatusChanged: {
                                    if (status === Image.Ready && !carrusel.appReady) {
                                        carrusel.loadedImagesCount++;

                                        let targetReady = Math.min(folderModel.count, 3);
                                        if (carrusel.loadedImagesCount >= targetReady) {
                                            carrusel.appReady = true;
                                            bgContainer.active = true;
                                        }
                                    }
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (carrusel.currentIndex === index) {
                                    carrusel.applyWallpaper();
                                } else {
                                    carrusel.currentIndex = index;
                                }
                            }
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: "No hay imágenes en la carpeta"
                color: QsServices.Colors.color4
                font.pixelSize: 14
                visible: folderModel.count === 0
            }
        }
    }
}
