pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.config
import qs.services

Rectangle {
    id: root

    visible: MprisService.hasPlayer
    opacity: visible ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: Config.animDuration
        }
    }

    implicitWidth: visible ? mediaContent.implicitWidth + Config.padding * 2 : 0
    implicitHeight: Config.barHeight - 10
    radius: height / 2

    color: Config.surface1Color

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Config.animDurationLong
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        id: mediaContent
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 10
        spacing: 8

        // Album Art
        Item {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: Config.surface2Color
            }

            Image {
                id: coverSource
                anchors.fill: parent
                source: MprisService.artUrl
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            Rectangle {
                id: coverMask
                anchors.fill: parent
                radius: 4
                visible: false
            }

            OpacityMask {
                anchors.fill: parent
                source: coverSource
                maskSource: coverMask
            }

            Text {
                visible: MprisService.artUrl == ""
                anchors.centerIn: parent
                text: ""
                font.family: Config.font
                font.pixelSize: 14
                color: Config.subtextColor
            }
        }

        // Song Info
        ColumnLayout {
            Layout.preferredWidth: 200
            spacing: 0

            Text {
                text: MprisService.title
                color: Config.textColor
                font.family: Config.font
                font.pixelSize: Config.fontSizeSmall
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: MprisService.artist
                color: Config.subtextColor
                font.family: Config.font
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Controls
        RowLayout {
            spacing: 5

            // Previous
            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: prevMouse.containsMouse ? Config.surface2Color : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: ""
                    font.family: Config.font
                    font.pixelSize: 14
                    color: Config.textColor
                }

                MouseArea {
                    id: prevMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: MprisService.previous()
                }

                Behavior on color {
                    ColorAnimation { duration: Config.animDurationShort }
                }
            }

            // Play/Pause
            Rectangle {
                width: 28
                height: 28
                radius: 14
                color: playMouse.containsMouse ? Qt.lighter(Config.accentColor, 1.1) : Config.accentColor

                scale: playMouse.pressed ? 0.9 : 1.0

                Behavior on scale {
                    NumberAnimation { duration: Config.animDurationShort }
                }

                Behavior on color {
                    ColorAnimation { duration: Config.animDurationShort }
                }

                Text {
                    anchors.centerIn: parent
                    text: MprisService.isPlaying ? "" : ""
                    font.family: Config.font
                    font.pixelSize: 14
                    color: Config.textReverseColor
                    anchors.horizontalCenterOffset: MprisService.isPlaying ? 0 : 1
                }

                MouseArea {
                    id: playMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: MprisService.playPause()
                }
            }

            // Next
            Rectangle {
                width: 24
                height: 24
                radius: 12
                color: nextMouse.containsMouse ? Config.surface2Color : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: ""
                    font.family: Config.font
                    font.pixelSize: 14
                    color: Config.textColor
                }

                MouseArea {
                    id: nextMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: MprisService.next()
                }

                Behavior on color {
                    ColorAnimation { duration: Config.animDurationShort }
                }
            }
        }
    }
}
