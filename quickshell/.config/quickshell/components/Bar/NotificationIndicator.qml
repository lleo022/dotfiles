import QtQuick
import "../../utils" as Utils

Rectangle {
    width: notifIcon.width + Utils.Theme.paddingMedium * 2
    height: parent.height
    color: "transparent"
    
    property int notificationCount: 0
    
    Text {
        id: notifIcon
        anchors.centerIn: parent
        text: notificationCount > 0 ? "󰂚" : "󰂛"
        color: Utils.Theme.foreground
        font.family: Utils.Theme.fontFamily
        font.pixelSize: Utils.Theme.fontSizeMedium
    }
    
    Rectangle {
        visible: notificationCount > 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 4
        width: 8
        height: 8
        radius: 4
        color: Utils.Theme.error
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // TODO: Toggle notification center
            console.log("Notifications clicked")
        }
    }
}