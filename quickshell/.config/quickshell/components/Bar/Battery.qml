import QtQuick
import Quickshell
import Quickshell.Io

import "../../utils" as Utils

Rectangle {
    id: batteryWidget
    
    width: batteryRow.width + Utils.Theme.paddingMedium * 2
    height: parent.height
    color: "transparent"
    
    property int percentage: 100
    property bool charging: false
    
    Process {
        id: batteryCheck
        running: true
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        
        stdout: SplitParser {
            onRead: data => {
                batteryWidget.percentage = parseInt(data)
            }
        }
    }
    
    Process {
        id: chargingCheck
        running: true
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        
        stdout: SplitParser {
            onRead: data => {
                batteryWidget.charging = data.trim() === "Charging"
            }
        }
    }
    
    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            batteryCheck.running = true
            chargingCheck.running = true
        }
    }
    
    Row {
        id: batteryRow
        anchors.centerIn: parent
        spacing: Utils.Theme.paddingSmall
        
        Text {
            text: batteryWidget.charging ? "󰂄" :
                  batteryWidget.percentage > 90 ? "󰁹" :
                  batteryWidget.percentage > 70 ? "󰂀" :
                  batteryWidget.percentage > 50 ? "󰁾" :
                  batteryWidget.percentage > 30 ? "󰁼" :
                  batteryWidget.percentage > 10 ? "󰁺" : "󰂃"
            color: batteryWidget.percentage < 20 ? Utils.Theme.error : Utils.Theme.foreground
            font.family: Utils.Theme.fontFamily
            font.pixelSize: Utils.Theme.fontSizeMedium
        }
        
        Text {
            text: batteryWidget.percentage + "%"
            color: Utils.Theme.foreground
            font.family: Utils.Theme.fontFamily
            font.pixelSize: Utils.Theme.fontSizeSmall
        }
    }
}