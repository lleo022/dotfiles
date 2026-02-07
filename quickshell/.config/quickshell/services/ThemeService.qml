pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: themeService

    // =========================================================================
    // PROPERTIES
    // =========================================================================

    property string themeName: "tokyonight"
    property string themePath: Quickshell.env("HOME") + "/.local/themes"
    property string statePath: Quickshell.env("HOME") + "/.config/quickshell/state.json"

    // Color palette
    property color background: "#1a1b26"
    property color foreground: "#a9b1d6"
    property color accent: "#7aa2f7"
    property color accentAlt: "#bb9af7"
    property color success: "#9ece6a"
    property color warning: "#e0af68"
    property color error: "#f7768e"
    property color muted: "#414868"

    // Derived colors
    property color barBg: Qt.rgba(background.r, background.g, background.b, 0.85)
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

    // Bar configuration
    property int barHeight: 36
    property string barPosition: "top"

    // =========================================================================
    // STATE FILE WATCHER - FIXED
    // =========================================================================

    property var stateWatcher: Process {
        running: true
        command: ["inotifywait", "-m", "-e", "modify", themeService.statePath]
        
        stdout: SplitParser {
            onRead: data => {
                console.log("[ThemeService] State file changed, reloading...")
                themeService.loadStateTimer.restart()
            }
        }
    }

    property Timer loadStateTimer: Timer {
        interval: 100
        repeat: false
        onTriggered: themeService.loadState()
    }

    // =========================================================================
    // FUNCTIONS
    // =========================================================================

    function loadState() {
        const process = Process.exec("cat", [statePath])
        
        if (process.exitCode !== 0) {
            console.warn("[ThemeService] State file doesn't exist, creating default")
            saveState()
            return
        }

        try {
            const data = JSON.parse(process.stdout)
            if (data.theme) {
                loadTheme(data.theme)
            }
            if (data.bar) {
                if (data.bar.height) barHeight = data.bar.height
                if (data.bar.position) barPosition = data.bar.position
            }
            console.log("[ThemeService] State loaded:", themeName)
        } catch (e) {
            console.error("[ThemeService] Failed to parse state:", e)
        }
    }

    function saveState() {
        const data = {
            theme: themeName,
            bar: {
                height: barHeight,
                position: barPosition
            }
        }

        const jsonStr = JSON.stringify(data, null, 2)
        Process.exec("sh", ["-c", `echo '${jsonStr}' > ${statePath}`])
        console.log("[ThemeService] State saved")
    }

    function loadTheme(name) {
        const themeFilePath = themePath + "/" + name + ".json"

        const process = Process.exec("cat", [themeFilePath])
        if (process.exitCode !== 0) {
            console.error("[ThemeService] Theme file not found:", themeFilePath)
            return false
        }

        try {
            const data = JSON.parse(process.stdout)

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
            barBg = Qt.rgba(background.r, background.g, background.b, 0.85)
            buttonBg = muted
            buttonHover = Qt.lighter(muted, 1.2)
            border = Qt.rgba(accent.r, accent.g, accent.b, 0.3)

            themeName = name
            console.log("[ThemeService] Theme loaded:", name)

            // Apply wallpaper if defined
            if (data.wallpaper) {
                const wallpaperPath = data.wallpaper.replace(/^~/, Quickshell.env("HOME"))
                Process.exec("swww", ["img", wallpaperPath, "--transition-type", "fade"])
            }

            return true
        } catch (e) {
            console.error("[ThemeService] Failed to parse theme:", e)
            return false
        }
    }

    // =========================================================================
    // INITIALIZATION
    // =========================================================================

    Component.onCompleted: {
        // Create state directory if doesn't exist
        Process.exec("mkdir", ["-p", Quickshell.env("HOME") + "/.config/quickshell"])
        
        loadState()
    }
}