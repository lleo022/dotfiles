import QtQuick
import Quickshell
import Quickshell.Io

import "../../utils" as Utils

Rectangle {
    id: networkWidget
    
    width: networkIcon.width + Utils.Theme.paddingMedium * 2
    height: parent.height
    color: "transparent"
    
    property bool connected: false
    property string connectionType: "wifi"
    
    Process {
        id: networkCheck
        running: true
        command: ["nmcli", "-t", "-f", "TYPE,STATE", "connection", "show", "--active"]
        
        stdout: SplitParser {
            onRead: data => {
                networkWidget.connected = data.includes("activated")
                networkWidget.connectionType = data.includes("ethernet") ? "ethernet" : "wifi"
            }
        }
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: networkCheck.running = true
    }
    
    Text {
        id: networkIcon
        anchors.centerIn: parent
        text: networkWidget.connected ? 
              (networkWidget.connectionType === "ethernet" ? "󰈀" : "󰖨") : 
              "󰖪"
        color: networkWidget.connected ? Utils.Theme.foreground : Utils.Theme.muted
        font.family: Utils.Theme.fontFamily
        font.pixelSize: Utils.Theme.fontSizeMedium
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // TODO: Open network settings
            console.log("Network settings clicked")
        }
    }
}