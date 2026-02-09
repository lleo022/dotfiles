pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    // Returns true if a laptop battery was found
    readonly property bool hasBattery: mainBattery !== null

    // Percentage (0 to 100)
    readonly property int percentage: mainBattery ? Math.round(mainBattery.percentage * 100) : 0

    // State (Charging, Discharging, Full...)
    readonly property int state: mainBattery ? mainBattery.state : UPowerDeviceState.Unknown

    // Boolean helper to simplify UI bindings
    readonly property bool isCharging: state === UPowerDeviceState.Charging

    // Holds the reference to the battery object
    property var mainBattery: null

    // The Instantiator scans the device list without creating visuals
    Instantiator {
        model: UPower.devices

        delegate: QtObject {
            required property var modelData
            
            // When a device is created or changes, we check if it is the main battery
            Component.onCompleted: checkDevice()
            
            function checkDevice() {
                if (modelData && modelData.isLaptopBattery) {
                    root.mainBattery = modelData
                }
            }
        }
    }

    // Icon logic here.
    function getBatteryIcon() {
        // Error or no battery found
        if (!hasBattery || state === UPowerDeviceState.Unknown || state === UPowerDeviceState.Empty) return "󰂃"

        // Charging state
        if (state === UPowerDeviceState.Charging) return "󰂄"
    
        // Discharging state
        const p = percentage
        const level = Math.floor(p / 10) * 10;
        const iconSet = {
            100: "󰁹", 90: "󰁹", 80: "󰂂", 70: "󰂁",60: "󰂀", 
            50: "󰁿", 40: "󰁾", 30: "󰁽", 20: "󰁼", 10: "󰁻", 0: "󰁺"
        };
        return iconSet[level] || "󰁺";
    }

}