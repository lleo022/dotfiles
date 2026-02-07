import QtQuick
import Quickshell

import "../../utils" as Utils

Rectangle {
    id: clockWidget
    
    width: clockText.width + Utils.Theme.paddingMedium * 2
    height: parent.height
    color: "transparent"
    
    property string currentTime: ""
    property string currentDate: ""
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        
        onTriggered: {
            var now = new Date()
            clockWidget.currentTime = Qt.formatDateTime(now, "HH:mm")
            clockWidget.currentDate = Qt.formatDateTime(now, "ddd, MMM dd")
        }
    }
    
    Text {
        id: clockText
        anchors.centerIn: parent
        text: clockWidget.currentTime
        color: Utils.Theme.foreground
        font.family: Utils.Theme.fontFamily
        font.pixelSize: Utils.Theme.fontSizeMedium
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
        
        onClicked: {
            // TODO: Open calendar
            console.log("Calendar clicked")
        }
    }
}