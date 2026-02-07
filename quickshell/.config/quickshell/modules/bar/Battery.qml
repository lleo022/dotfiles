import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services

Rectangle {
    id: batteryWidget

    implicitWidth: batteryRow.width + ThemeService.paddingMedium * 2
    implicitHeight: parent.height
    color: "transparent"

    property int percentage: 100
    property bool charging: false

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: batteryWidget.updateBattery()
    }

    function updateBattery() {
        const capacityProcess = Process.exec("cat", ["/sys/class/power_supply/BAT0/capacity"])
        if (capacityProcess.exitCode === 0) {
            percentage = parseInt(capacityProcess.stdout.trim())
        }

        const statusProcess = Process.exec("cat", ["/sys/class/power_supply/BAT0/status"])
        if (statusProcess.exitCode === 0) {
            charging = statusProcess.stdout.trim() === "Charging"
        }
    }

    Row {
        id: batteryRow
        anchors.centerIn: parent
        spacing: ThemeService.paddingSmall

        Text {
            text: batteryWidget.charging ? "󰂄" :
                  batteryWidget.percentage > 90 ? "󰁹" :
                  batteryWidget.percentage > 70 ? "󰂀" :
                  batteryWidget.percentage > 50 ? "󰁾" :
                  batteryWidget.percentage > 30 ? "󰁼" :
                  batteryWidget.percentage > 10 ? "󰁺" : "󰂃"
            color: batteryWidget.percentage < 20 ? ThemeService.error : ThemeService.foreground
            font.family: ThemeService.fontFamily
            font.pixelSize: ThemeService.fontSizeMedium
        }

        Text {
            text: batteryWidget.percentage + "%"
            color: ThemeService.foreground
            font.family: ThemeService.fontFamily
            font.pixelSize: ThemeService.fontSizeSmall
        }
    }
}