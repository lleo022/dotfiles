pragma Singleton
import QtQuick

QtObject {
    id: osdService

    // =========================================================================
    // PROPERTIES
    // =========================================================================

    property bool visible: false
    property string type: "volume"  // "volume" or "brightness"
    property int value: 0
    property bool isMuted: false

    // =========================================================================
    // TIMER
    // =========================================================================

    property Timer hideTimer: Timer {
        interval: 2000
        running: false
        repeat: false

        onTriggered: {
            osdService.visible = false
        }
    }

    // =========================================================================
    // FUNCTIONS
    // =========================================================================

    function showVolume(volume, muted) {
        type = "volume"
        value = volume
        isMuted = muted
        visible = true

        hideTimer.restart()
    }

    function showBrightness(brightness) {
        type = "brightness"
        value = brightness
        isMuted = false
        visible = true

        hideTimer.restart()
    }

    function hide() {
        visible = false
        hideTimer.stop()
    }
}