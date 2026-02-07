pragma Singleton
import QtQuick
import Quickshell.Io

QtObject {
    id: config
    
    // Config file path
    property string configPath: Quickshell.env("HOME") + "/.config/quickshell/state.json"
    
    // Default values
    property string currentTheme: "tokyonight"
    property string wallpaper: Quickshell.env("HOME") + "/.local/wallpapers/default.png"
    property int barHeight: 36
    property string barPosition: "top"
    
    // File watcher for config changes
    FileView {
        id: configFile
        path: config.configPath
        
        onContentChanged: {
            loadConfig()
        }
    }
    
    // Load configuration from file
    function loadConfig() {
        if (configFile.exists) {
            try {
                var data = JSON.parse(configFile.text)
                if (data.theme) currentTheme = data.theme
                if (data.wallpaper) wallpaper = data.wallpaper
                if (data.bar) {
                    if (data.bar.height) barHeight = data.bar.height
                    if (data.bar.position) barPosition = data.bar.position
                }
                console.log("Config loaded:", currentTheme)
            } catch (e) {
                console.error("Failed to parse config:", e)
            }
        } else {
            // Create default config
            saveConfig()
        }
    }
    
    // Save configuration to file
    function saveConfig() {
        var data = {
            theme: currentTheme,
            wallpaper: wallpaper,
            bar: {
                height: barHeight,
                position: barPosition
            }
        }
        
        configFile.text = JSON.stringify(data, null, 2)
    }
    
    // Initialize
    Component.onCompleted: {
        loadConfig()
    }
}