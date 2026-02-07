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

    GlobalShortcut {
        name: "volume_up"
        description: "Increase volume"

        onPressed: {
            AudioService.increaseVolume()
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }

    GlobalShortcut {
        name: "volume_down"
        description: "Decrease volume"

        onPressed: {
            AudioService.decreaseVolume()
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }

    GlobalShortcut {
        name: "volume_mute"
        description: "Mute volume"

        onPressed: {
            AudioService.toggleMute()
            OsdService.showVolume(AudioService.volume, AudioService.muted)
        }
    }
}
```

---

## **Step 4: Verify Directory Structure**

Your structure after stowing should be:
```
~/.config/quickshell/
├── shell.qml
├── services/
│   ├── qmldir              # CRITICAL!
│   ├── ThemeService.qml
│   ├── AudioService.qml
│   └── OsdService.qml
├── modules/
│   ├── bar/
│   │   ├── Bar.qml
│   │   ├── Workspaces.qml
│   │   ├── Clock.qml
│   │   ├── Audio.qml
│   │   ├── Battery.qml
│   │   └── Network.qml
│   └── osd/
│       └── OsdOverlay.qml
└── state.json              # Created at runtime