pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.services

RowLayout {
    id: workspaces

    required property var screen

    spacing: ThemeService.paddingSmall

    Repeater {
        model: 10

        Rectangle {
            id: workspace

            required property int index

            property int workspaceId: index + 1
            property bool isActive: {
                const monitor = Hyprland.monitors.values.find(m => m.name === workspaces.screen.name)
                return monitor ? monitor.activeWorkspace.id === workspaceId : false
            }
            property bool hasWindows: {
                const ws = Hyprland.workspaces.values.find(w => w.id === workspaceId)
                return ws ? ws.windows.values.length > 0 : false
            }

            Layout.preferredWidth: 30
            Layout.preferredHeight: 24
            radius: ThemeService.borderRadius

            color: isActive ? ThemeService.accent :
                   hasWindows ? ThemeService.buttonBg :
                   "transparent"

            border.width: hasWindows && !isActive ? 1 : 0
            border.color: ThemeService.border

            Text {
                anchors.centerIn: parent
                text: workspace.workspaceId
                color: workspace.isActive ? ThemeService.background : ThemeService.foreground
                font.family: ThemeService.fontFamily
                font.pixelSize: ThemeService.fontSizeMedium
                font.bold: workspace.isActive
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Hyprland.dispatch("workspace", workspace.workspaceId.toString())
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }
}