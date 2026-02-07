//@ pragma Env QS_NO_RELOAD_POPUP=1
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.services

ShellRoot {
    id: root

    // =========================================================================
    // UI COMPONENTS
    // =========================================================================

    // Bar - always active
    Loader {
        active: true
        source: "./modules/bar/Bar.qml"
    }

    // OSD - lazy loaded
    Loader {
        active: OsdService.visible
        source: "./modules/osd/OsdOverlay.qml"
    }

    // =========================================================================
    // GLOBAL SHORTCUTS
    // =========================================================================

    // Volume Up
    GlobalShortcut {
        name: "volume_up"
        description: "Increase volume"

        onPressed: {
            AudioService.increaseVolume()
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }

    // Volume Down
    GlobalShortcut {
        name: "volume_down"
        description: "Decrease volume"

        onPressed: {
            AudioService.decreaseVolume()
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }

    // Volume Mute
    GlobalShortcut {
        name: "volume_mute"
        description: "Mute volume"

        onPressed: {
            AudioService.toggleMute()
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }
}
