pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import "../../components/"

BarButton {
    id: root

    active: quickSettingsWindow.visible
    contentItem: pillContent
    onClicked: quickSettingsWindow.visible = !quickSettingsWindow.visible

    RowLayout {
        id: pillContent
        anchors.centerIn: parent
        spacing: Config.spacing

        property color iconColor: root.active ? Config.accentColor : Config.textColor

        Behavior on iconColor {
            ColorAnimation {
                duration: Config.animDuration
            }
        }

        // Bluetooth
        BluetoothIcon {
            color: pillContent.iconColor
        }

        // Separator
        Rectangle {
            width: 1
            height: 14
            color: Qt.alpha(Config.surface2Color, 0.5)
        }

        // WiFi
        WifiIcon {
            color: pillContent.iconColor
        }

        // Separator
        Rectangle {
            width: 1
            height: 14
            color: Qt.alpha(Config.surface2Color, 0.5)
        }

        // Volume
        Text {
            text: AudioService.systemIcon
            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal
            font.bold: true
            color: pillContent.iconColor
        }

        // Separator (only if battery present)
        Rectangle {
            visible: BatteryService.hasBattery
            width: 1
            height: 14
            color: Qt.alpha(Config.surface2Color, 0.5)
        }

        // Battery
        RowLayout {
            visible: BatteryService.hasBattery
            spacing: 3

            BatteryIcon {
                color: pillContent.iconColor
            }

            Text {
                text: BatteryService.percentage + "%"
                font.family: Config.font
                font.pixelSize: Config.fontSizeSmall
                font.bold: true
                color: pillContent.iconColor
            }
        }
    }

    QuickSettingsWindow {
        id: quickSettingsWindow
        visible: false
    }
}
