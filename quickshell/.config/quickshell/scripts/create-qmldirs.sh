#!/bin/bash
# create-qmldirs.sh

MODULES_DIR="$HOME/.config/quickshell/modules"

# Calendar module
cat > "$MODULES_DIR/calendar/qmldir" << 'EOF'
CalendarButton 1.0 CalendarButton.qml
CalendarWindow 1.0 CalendarWindow.qml
EOF

# System Monitor module
cat > "$MODULES_DIR/systemMonitor/qmldir" << 'EOF'
SystemMonitorButton 1.0 SystemMonitorButton.qml
SystemMonitorWindow 1.0 SystemMonitorWindow.qml
EOF

# Notifications module
cat > "$MODULES_DIR/notifications/qmldir" << 'EOF'
NotificationButton 1.0 NotificationButton.qml
NotificationCard 1.0 NotificationCard.qml
NotificationOverlay 1.0 NotificationOverlay.qml
NotificationWindow 1.0 NotificationWindow.qml
EOF

# Quick Settings module
cat > "$MODULES_DIR/quickSettings/qmldir" << 'EOF'
QuickSettingsButton 1.0 QuickSettingsButton.qml
QuickSettingsTile 1.0 QuickSettingsTile.qml
QuickSettingsWindow 1.0 QuickSettingsWindow.qml
MediaWidget 1.0 MediaWidget.qml
EOF

echo "All qmldir files created!"