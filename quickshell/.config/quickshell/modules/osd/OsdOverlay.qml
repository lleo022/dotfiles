pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.services

Scope {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            FloatingWindow {
                id: osdWindow

                required property var modelData

                screen: modelData
                visible: OsdService.visible

                width: 300
                height: 100

                anchor {
                    horizontal: "center"
                    vertical: "center"
                }

                color: "transparent"

                Rectangle {
                    anchors.fill: parent
                    color: ThemeService.background
                    radius: ThemeService.borderRadius * 2
                    border.width: 1
                    border.color: ThemeService.border

                    opacity: 0.95

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: ThemeService.paddingLarge
                        spacing: ThemeService.paddingMedium

                        // Icon and label
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: ThemeService.paddingMedium

                            Text {
                                text: {
                                    if (OsdService.type === "volume") {
                                        return OsdService.isMuted ? "󰖁" :
                                               OsdService.value > 50 ? "" :
                                               OsdService.value > 0 ? "󰖀" : "󰕿"
                                    } else {
                                        return "󰃠"  // Brightness icon
                                    }
                                }
                                color: ThemeService.foreground
                                font.family: ThemeService.fontFamily
                                font.pixelSize: 32
                            }

                            Text {
                                text: OsdService.type === "volume" ? "Volume" : "Brightness"
                                color: ThemeService.foreground
                                font.family: ThemeService.fontFamily
                                font.pixelSize: ThemeService.fontSizeLarge
                                font.bold: true
                                Layout.fillWidth: true
                            }

                            Text {
                                text: OsdService.value + "%"
                                color: ThemeService.accent
                                font.family: ThemeService.fontFamily
                                font.pixelSize: ThemeService.fontSizeLarge
                                font.bold: true
                            }
                        }

                        // Progress bar
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 8
                            radius: 4
                            color: ThemeService.muted

                            Rectangle {
                                width: parent.width * (OsdService.value / 100)
                                height: parent.height
                                radius: parent.radius
                                color: OsdService.isMuted ? ThemeService.muted : ThemeService.accent

                                Behavior on width {
                                    NumberAnimation { duration: 100 }
                                }
                            }
                        }
                    }
                }

                // Fade in/out animation
                opacity: OsdService.visible ? 1.0 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
                }
            }
        }
    }
}