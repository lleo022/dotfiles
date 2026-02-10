pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config

Item {
    id: root

    // Graphics
    property color color: Config.textColor

    // Battery data
    readonly property bool charging: BatteryService.isCharging
    readonly property real percentage: BatteryService.percentage / 100.0

    // Animation helper
    property real chargeFillIndex: percentage * 100

    // Size
    property int bodyWidth: 26
    property int bodyHeight: 12
    property int batteryRadius: 2


    visible: BatteryService.hasBattery
    implicitWidth: bodyWidth + 4
    implicitHeight: bodyHeight

    Layout.alignment: Qt.AlignVCenter

    onChargingChanged: {
        if (charging)
            chargeFillIndex = percentage * 100
    }

    // Battery body
    Rectangle {
        id: body

        width: bodyWidth
        height: bodyHeight
        radius: batteryRadius
        color: "transparent"
        border.width: 0.75
        border.color: percentage <= 0.2 && !charging
            ? Config.errorColor
            : Qt.rgba(root.color.r, root.color.g, root.color.b, 0.5)

        anchors.verticalCenter: parent.verticalCenter

        // Battery fill
        Rectangle {
            id: fill

            x: 2
            y: 2
            height: parent.height - 4
            width: charging
                ? (parent.width - 4) * (chargeFillIndex / 100.0)
                : (parent.width - 4) * percentage

            radius: batteryRadius - 2

            color: {
                if (charging)
                    return Config.successColor
                if (percentage <= 0.2)
                    return Config.errorColor
                if (percentage <= 0.5)
                    return Config.warningColor
                return Config.textColor
            }

            Behavior on width {
                enabled: !charging
                NumberAnimation {
                    duration: Config.animDuration
                }
            }
        }

        // Battery text
        Text {
            anchors.centerIn: parent
            text: Math.round(percentage * 100)

            font.family: Config.font
            font.pixelSize: parent.height * 0.65
            font.bold: true

            color: percentage <= 0.5
                ? Config.textColor
                : Config.textReverseColor

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // Battery tip
    Rectangle {
        width: 2
        height: 5
        radius: 1

        anchors.left: body.right
        anchors.leftMargin: 1
        anchors.verticalCenter: parent.verticalCenter

        color: percentage <= 0.2 && !charging
            ? Config.errorColor
            : Qt.rgba(Config.textColor.r,
                      Config.textColor.g,
                      Config.textColor.b,
                      0.5)
    }

    // Charging animation
    SequentialAnimation {
        running: charging
        loops: Animation.Infinite

        PauseAnimation { duration: Config.animDuration }

        NumberAnimation {
            target: root
            property: "chargeFillIndex"
            from: percentage * 100
            to: 100
            duration: Config.animDuration * 2
            easing.type: Easing.Linear
        }

        PauseAnimation { duration: Config.animDuration }

        NumberAnimation {
            target: root
            property: "chargeFillIndex"
            from: 100
            to: percentage * 100
            duration: Config.animDuration
            easing.type: Easing.Linear
        }

        onStopped: chargeFillIndex = percentage * 100
    }
}
