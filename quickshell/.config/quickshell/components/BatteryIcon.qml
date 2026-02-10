pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import "../../components/"

Item {
    id: root

    // Battery data (normalized to 0–1)
    readonly property bool batCharging: BatteryService.isCharging
    readonly property real batPercentage: BatteryService.percentage / 100.0

    // Animation helper
    property real chargeFillIndex: batPercentage * 100

    // Sizing (taskbar-friendly)
    property int widthBattery: 26
    property int heightBattery: 12

    visible: BatteryService.hasBattery

    implicitWidth: widthBattery + 4
    implicitHeight: heightBattery

    Layout.alignment: Qt.AlignVCenter

    onBatChargingChanged: {
        if (batCharging)
            chargeFillIndex = batPercentage * 100
    }

    // Battery body
    StyledRect {
        id: batteryBody

        implicitWidth: root.widthBattery
        implicitHeight: root.heightBattery
        clip: true
        color: "transparent"
        radius: 3

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        border {
            width: 2
            color: batPercentage <= 0.2 && !batCharging
                ? Config.errorColor
                : Qt.rgba(Config.textColor.r, Config.textColor.g, Config.textColor.b, 0.5)
        }

        // Battery fill
        StyledRect {
            anchors {
                left: parent.left
                leftMargin: 2
                top: parent.top
                topMargin: 2
                bottom: parent.bottom
                bottomMargin: 2
            }

            implicitWidth: batCharging
                ? (parent.width - 4) * (chargeFillIndex / 100.0)
                : (parent.width - 4) * batPercentage

            radius: parent.radius - 2

            color: {
                if (batCharging)
                    return Config.successColor
                if (batPercentage <= 0.2)
                    return Config.errorColor
                if (batPercentage <= 0.5)
                    return Config.warningColor ?? Config.accentColor
                return Config.textColor
            }

            Behavior on implicitWidth {
                enabled: !batCharging
                NumberAnimation {
                    duration: Config.animDuration
                }
            }
        }
    }

    // Battery tip
    StyledRect {
        implicitWidth: 2
        implicitHeight: 5

        anchors {
            left: batteryBody.right
            leftMargin: 0.5
            verticalCenter: parent.verticalCenter
        }

        color: batPercentage <= 0.2 && !batCharging
            ? Config.errorColor
            : Qt.rgba(Config.textColor.r, Config.textColor.g, Config.textColor.b, 0.5)

        topRightRadius: 1
        bottomRightRadius: 1
    }

    // Charging animation
    SequentialAnimation {
        running: batCharging
        loops: Animation.Infinite

        PauseAnimation { duration: Config.animDuration }

        NumberAnimation {
            target: root
            property: "chargeFillIndex"
            from: batPercentage * 100
            to: 100
            duration: Config.animDuration * 2
            easing.type: Easing.Linear
        }

        PauseAnimation { duration: Config.animDuration }

        NumberAnimation {
            target: root
            property: "chargeFillIndex"
            from: 100
            to: batPercentage * 100
            duration: Config.animDuration
            easing.type: Easing.Linear
        }

        onStopped: {
            chargeFillIndex = batPercentage * 100
        }
    }
}
