import QtQuick
import "../../utils" as Utils

Text {
    text: ""
    color: Utils.Theme.foreground
    font.family: Utils.Theme.fontFamily
    font.pixelSize: Utils.Theme.fontSizeMedium
    
    // TODO: Implement actual system tray
    // This requires StatusNotifierItem support
}