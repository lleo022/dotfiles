pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: theme
    
    property string themeName: "tokyonight"
    property string themePath: Quickshell.env("HOME") + "/.local/themes"
    
    // Color palette
    property color background: "#1a1b26"
    property color foreground: "#a9b1d6"
    property color accent: "#7aa2f7"
    property color accentAlt: "#bb9af7"
    property color success: "#9ece6a"
    property color warning: "#e0af68"
    property color error: "#f7768e"
    property color muted: "#414868"
    
    // UI specific colors
    property color barBg: Qt.rgba(background.r, background.g, background.b, 0.9)
    property color buttonBg: muted
    property color buttonHover: Qt.lighter(muted, 1.2)
    property color border: Qt.rgba(accent.r, accent.g, accent.b, 0.3)
    
    // Typography
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSizeSmall: 11
    property int fontSizeMedium: 13
    property int fontSizeLarge: 15
    
    // Spacing
    property int paddingSmall: 4
    property int paddingMedium: 8
    property int paddingLarge: 12
    property int borderRadius: 8
    
    // Load theme from file
    function loadTheme(name) {
        var themeFile = themePath + "/" + name + ".json"
        
        var process = Process.run("cat", [themeFile])
        if (process.exitCode === 0) {
            try {
                var data = JSON.parse(process.stdout)
                
                // Load palette
                if (data.palette) {
                    if (data.palette.background) background = data.palette.background
                    if (data.palette.foreground) foreground = data.palette.foreground
                    if (data.palette.accent) accent = data.palette.accent
                    if (data.palette.accentAlt) accentAlt = data.palette.accentAlt
                    if (data.palette.success) success = data.palette.success
                    if (data.palette.warning) warning = data.palette.warning
                    if (data.palette.error) error = data.palette.error
                    if (data.palette.muted) muted = data.palette.muted
                }
                
                // Update derived colors
                barBg = Qt.rgba(background.r, background.g, background.b, 0.9)
                buttonBg = muted
                buttonHover = Qt.lighter(muted, 1.2)
                border = Qt.rgba(accent.r, accent.g, accent.b, 0.3)
                
                themeName = name
                console.log("Theme loaded:", name)
                
                return true
            } catch (e) {
                console.error("Failed to parse theme:", e)
                return false
            }
        } else {
            console.error("Theme file not found:", themeFile)
            return false
        }
    }
    
    // Initialize
    Component.onCompleted: {
        loadTheme(themeName)
    }
}