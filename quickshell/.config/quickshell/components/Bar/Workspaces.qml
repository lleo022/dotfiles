import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

import "../../utils" as Utils

RowLayout {
    id: workspaces
    
    required property var screen
    
    spacing: Utils.Theme.paddingSmall
    
    Repeater {
        model: 10
        
        Rectangle {
            id: workspace
            
            property int workspaceId: index + 1
            property bool isActive: Hyprland.focusedMonitor.activeWorkspace.id === workspaceId
            property bool hasWindows: {
                for (var i = 0; i < Hyprland.workspaces.values.length; i++) {
                    var ws = Hyprland.workspaces.values[i]
                    if (ws.id === workspaceId) {
                        return ws.windows.values.length > 0
                    }
                }
                return false
            }
            
            width: 30
            height: 24
            radius: Utils.Theme.borderRadius
            
            color: isActive ? Utils.Theme.accent : 
                   hasWindows ? Utils.Theme.buttonBg : 
                   "transparent"
            
            border.width: hasWindows && !isActive ? 1 : 0
            border.color: Utils.Theme.border
            
            Text {
                anchors.centerIn: parent
                text: workspace.workspaceId
                color: workspace.isActive ? Utils.Theme.background : Utils.Theme.foreground
                font.family: Utils.Theme.fontFamily
                font.pixelSize: Utils.Theme.fontSizeMedium
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