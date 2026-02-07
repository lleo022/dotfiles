import QtQuick
import "../../utils" as Utils

Rectangle {
    width: powerIcon.width + Utils.Theme.paddingMedium * 2
    height: parent.height
    radius: Utils.Theme.borderRadius
    color: mouseArea.containsMouse ? Utils.Theme.buttonHover : "transparent"
    
    Text {
        id: powerIcon
        anchors.centerIn: parent
        text: "⏻"
        color: Utils.Theme.foreground
        font.family: Utils.Theme.fontFamily
        font.pixelSize: Utils.Theme.fontSizeMedium
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        onClicked: {
            // TODO: Open power menu
            console.log("Power menu clicked")
        }
    }
    
    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}