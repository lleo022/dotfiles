import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../utils" as Utils
import "../Bar" as Bar

PanelWindow {
    id: bar
    
    required property var screen
    
    anchors {
        top: true
        left: true
        right: true
    }
    
    height: Utils.Config.barHeight
    color: "transparent"
    
    exclusionMode: ExclusionMode.Exclusive
    
    Rectangle {
        anchors.fill: parent
        color: Utils.Theme.barBg
        radius: 0
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Utils.Theme.paddingMedium
            spacing: Utils.Theme.paddingMedium
            
            // Left modules
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: Utils.Theme.paddingSmall
                
                Bar.Workspaces {
                    screen: bar.screen
                }
                
                Bar.WindowTitle {}
            }
            
            // Center modules
            Item {
                Layout.fillWidth: true
                
                Bar.Clock {
                    anchors.centerIn: parent
                }
            }
            
            // Right modules
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: Utils.Theme.paddingSmall
                
                Bar.SystemTray {}
                
                Bar.Separator {}
                
                Bar.Network {}
                
                Bar.Audio {}
                
                Bar.Battery {}
                
                Bar.Separator {}
                
                Bar.NotificationIndicator {}
                
                Bar.PowerButton {}
            }
        }
    }
}