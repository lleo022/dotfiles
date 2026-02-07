import QtQuick
import Quickshell
import qs.services

Rectangle {
    id: clockWidget

    implicitWidth: clockText.width + ThemeService.paddingMedium * 2
    implicitHeight: parent.height
    color: "transparent"

    property string currentTime: ""
    property string currentDate: ""

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            const now = new Date()
            clockWidget.currentTime = Qt.formatDateTime(now, "HH:mm")
            clockWidget.currentDate = Qt.formatDateTime(now, "ddd, MMM dd")
        }
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        text: clockWidget.currentTime
        color: ThemeService.foreground
        font.family: ThemeService.fontFamily
        font.pixelSize: ThemeService.fontSizeMedium
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            clockText.text = clockWidget.currentDate
        }

        onExited: {
            clockText.text = clockWidget.currentTime
        }
    }
}