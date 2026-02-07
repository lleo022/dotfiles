import Quickshell
import Quickshell.Wayland
import QtQuick

import "components/Bar" as BarComponents
import "utils" as Utils

ShellRoot {
    // Load configuration and theme
    Utils.Config {
        id: config
    }

    Utils.Theme {
        id: theme
        themeName: config.currentTheme
    }

    // Create a bar on each monitor
    Variants {
        model: Quickshell.screens
        
        delegate: Component {
            BarComponents.MainBar {
                screen: modelData
            }
        }
    }

    // Global services
    Component.onCompleted: {
        console.log("QuickShell started")
        console.log("Current theme:", theme.themeName)
    }
}