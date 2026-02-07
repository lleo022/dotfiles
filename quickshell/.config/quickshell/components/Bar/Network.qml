import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Rectangle {
    id: networkWidget

    implicitWidth: networkIcon.width + ThemeService.paddingMedium * 2
    implicitHeight: parent.height
    color: "transparent"

    property bool connected: false
    property string connectionType: "wifi"

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: networkWidget.updateNetwork()
    }

    function updateNetwork() {
        const process = Process.exec("nmcli", ["-t", "-f", "TYPE,STATE", "connection", "show", "--active"])
        if (process.exitCode === 0) {
            const output = process.stdout
            connected = output.includes("activated")
            connectionType = output.includes("ethernet") ? "ethernet" : "wifi"
        }
    }

    Text {
        id: networkIcon
        anchors.centerIn: parent
        text: networkWidget.connected ?
              (networkWidget.connectionType === "ethernet" ? "󰈀" : "󰖨") :
              "󰖪"
        color: networkWidget.connected ? ThemeService.foreground : ThemeService.muted
        font.family: ThemeService.fontFamily
        font.pixelSize: ThemeService.fontSizeMedium
    }
}