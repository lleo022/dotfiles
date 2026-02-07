pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: audioService

    // =========================================================================
    // PROPERTIES
    // =========================================================================

    property int volume: 50
    property bool muted: false

    // =========================================================================
    // POLLING TIMER
    // =========================================================================

    property Timer updateTimer: Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: audioService.updateVolume()
    }

    // =========================================================================
    // FUNCTIONS
    // =========================================================================

    function updateVolume() {
        // Get volume
        const volProcess = Process.exec("pamixer", ["--get-volume"])
        if (volProcess.exitCode === 0) {
            volume = parseInt(volProcess.stdout.trim())
        }

        // Get mute status
        const muteProcess = Process.exec("pamixer", ["--get-mute"])
        if (muteProcess.exitCode === 0) {
            muted = muteProcess.stdout.trim() === "true"
        }
    }

    function increaseVolume() {
        Process.exec("pamixer", ["-i", "5"])
        updateVolume()
    }

    function decreaseVolume() {
        Process.exec("pamixer", ["-d", "5"])
        updateVolume()
    }

    function toggleMute() {
        Process.exec("pamixer", ["--toggle-mute"])
        updateVolume()
    }

    function setVolume(value) {
        Process.exec("pamixer", ["--set-volume", value.toString()])
        updateVolume()
    }
}