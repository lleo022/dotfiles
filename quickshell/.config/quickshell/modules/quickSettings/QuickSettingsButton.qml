pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import "../../components/"

BarButton {
    id: root

    active: quickSettingsWindow.visible
    contentItem: iconsLayout
    onClicked: quickSettingsWindow.visible = !quickSettingsWindow.visible

    RowLayout {
        id: iconsLayout
        anchors.centerIn: parent
        spacing: Config.spacing

        property color iconColor: root.active ? Config.accentColor : Config.textColor

        Behavior on iconColor {
            ColorAnimation {
                duration: Config.animDuration
            }
        }

        // Wifi Icon
        WifiIcon {
            color: iconsLayout.iconColor
        }
        BluetoothIcon {
            color: iconsLayout.iconColor
        }
        // Battery Icon and Percentages
        BatteryIcon {
            color: iconsLayout.iconColor
        }
        Text {
            visible: BatteryService.hasBattery
            text: BatteryService.percentage + "%"
            font.family: Config.font
            font.pixelSize: Config.fontSizeSmall
            font.bold: true
            color: iconsLayout.iconColor
        }
    }

    QuickSettingsWindow {
        id: quickSettingsWindow
        visible: false
    }
}
