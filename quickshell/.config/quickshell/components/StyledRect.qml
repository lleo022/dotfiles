import QtQuick
import qs.config

Rectangle {
    color: "transparent"
    radius: Appearance.rounding.normal

    Behavior on color {
        CAnim {}
    }
}