pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.services
import "../../components" as Components

Scope {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: bar

                required property var modelData

                screen: modelData

                anchors {
                    top: ThemeService.barPosition === "top"
                    bottom: ThemeService.barPosition === "bottom"
                    left: true
                    right: true
                }

                height: ThemeService.barHeight
                color: "transparent"
                exclusionMode: ExclusionMode.Exclusive

                Rectangle {
                    anchors.fill: parent
                    color: ThemeService.barBg
                    radius: 0

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: ThemeService.paddingMedium
                        anchors.rightMargin: ThemeService.paddingMedium
                        spacing: ThemeService.paddingMedium

                        // Left modules
                        RowLayout {
                            Layout.alignment: Qt.AlignLeft
                            spacing: ThemeService.paddingSmall

                            Components.Workspaces {
                                screen: bar.modelData
                            }
                        }

                        // Center spacer
                        Item {
                            Layout.fillWidth: true
                        }

                        // Center modules
                        Components.Clock {}

                        // Right spacer
                        Item {
                            Layout.fillWidth: true
                        }

                        // Right modules
                        RowLayout {
                            Layout.alignment: Qt.AlignRight
                            spacing: ThemeService.paddingSmall

                            Components.Network {}

                            Rectangle {
                                width: 1
                                height: 16
                                color: ThemeService.border
                            }

                            Components.Audio {}

                            Components.Battery {}
                        }
                    }
                }
            }
        }
    }
}