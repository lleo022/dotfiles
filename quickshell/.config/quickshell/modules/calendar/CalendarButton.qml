pragma ComponentBehavior: Bound
import QtQuick
import qs.config
import qs.services
import "../../components/"

BarButton {
    id: root

    active: calendarWindow.visible
    contentItem: clockContent
    onClicked: calendarWindow.visible = !calendarWindow.visible

    Row {
        id: clockContent
        anchors.centerIn: parent
        spacing: 8

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: TimeService.format("h:mm AP")
            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal
            font.bold: true
            color: root.active ? Config.accentColor : Config.textColor

            Behavior on color {
                ColorAnimation { duration: Config.animDuration }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                const d = TimeService.date;
                const month = d.getMonth() + 1;  // getMonth() returns 0-11
                const day = d.getDate();
                const year = d.getFullYear();
                return month + "/" + day + "/" + year;
            }
            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal
            font.bold: true
            color: root.active ? Config.accentColor : Config.textColor

            Behavior on color {
                ColorAnimation { duration: Config.animDuration }
            }
        }
    }

    CalendarWindow {
        id: calendarWindow
        visible: false
    }
}