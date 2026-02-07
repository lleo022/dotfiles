import QtQuick
import Quickshell
import Quickshell.Io

import "../../utils" as Utils

Rectangle {
    id: audioWidget
    
    width: audioRow.width + Utils.Theme.paddingMedium * 2
    height: parent.height
    radius: Utils.Theme.borderRadius
    color: "transparent"
    
    property int volume: 50
    property bool muted: false
    
    Process {
        id: volumeCheck
        running: true
        command: ["pamixer", "--get-volume"]
        
        stdout: SplitParser {
            onRead: data => {
                audioWidget.volume = parseInt(data)
            }
        }
    }
    
    Process {
        id: muteCheck
        running: true
        command: ["pamixer", "--get-mute"]
        
        stdout: SplitParser {
            onRead: data => {
                audioWidget.muted = data.trim() === "true"
            }
        }
    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            volumeCheck.running = true
            muteCheck.running = true
        }
    }
    
    Row {
        id: audioRow
        anchors.centerIn: parent
        spacing: Utils.Theme.paddingSmall
        
        Text {
            text: audioWidget.muted ? "󰖁" : 
                  audioWidget.volume > 50 ? "" : 
                  audioWidget.volume > 0 ? "󰖀" : "󰕿"
            color: audioWidget.muted ? Utils.Theme.muted : Utils.Theme.foreground
            font.family: Utils.Theme.fontFamily
            font.pixelSize: Utils.Theme.fontSizeMedium
        }
        
        Text {
            text: audioWidget.volume + "%"
            color: Utils.Theme.foreground
            font.family: Utils.Theme.fontFamily
            font.pixelSize: Utils.Theme.fontSizeSmall
            visible: !audioWidget.muted
        }
    }
    
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                Process.run("pamixer", ["--toggle-mute"])
            } else if (mouse.button === Qt.RightButton) {
                // TODO: Open audio settings
                console.log("Audio settings clicked")
            }
        }
        
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                Process.run("pamixer", ["-i", "5"])
            } else {
                Process.run("pamixer", ["-d", "5"])
            }
        }
    }
}