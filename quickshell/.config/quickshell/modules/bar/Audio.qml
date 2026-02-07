import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services

Rectangle {
    id: audioWidget

    implicitWidth: audioRow.width + ThemeService.paddingMedium * 2
    implicitHeight: parent.height
    radius: ThemeService.borderRadius
    color: mouseArea.containsMouse ? ThemeService.buttonHover : "transparent"

    Row {
        id: audioRow
        anchors.centerIn: parent
        spacing: ThemeService.paddingSmall

        Text {
            text: AudioService.muted ? "󰖁" :
                  AudioService.volume > 50 ? "" :
                  AudioService.volume > 0 ? "󰖀" : "󰕿"
            color: AudioService.muted ? ThemeService.muted : ThemeService.foreground
            font.family: ThemeService.fontFamily
            font.pixelSize: ThemeService.fontSizeMedium
        }

        Text {
            text: AudioService.volume + "%"
            color: ThemeService.foreground
            font.family: ThemeService.fontFamily
            font.pixelSize: ThemeService.fontSizeSmall
            visible: !AudioService.muted
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                AudioService.toggleMute()
                OsdService.showVolume(AudioService.volume, AudioService.muted)
            }
        }

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                AudioService.increaseVolume()
            } else {
                AudioService.decreaseVolume()
            }
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}