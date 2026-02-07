import Quickshell
import Quickshell.Hyprland
import QtQuick

import "../../utils" as Utils

Text {
    id: windowTitle
    
    property var activeWindow: Hyprland.focusedMonitor.activeWindow
    
    text: activeWindow ? activeWindow.title : "Desktop"
    color: Utils.Theme.muted
    font.family: Utils.Theme.fontFamily
    font.pixelSize: Utils.Theme.fontSizeMedium
    
    elide: Text.ElideRight
    
    Layout.fillWidth: true
    Layout.maximumWidth: 300
}