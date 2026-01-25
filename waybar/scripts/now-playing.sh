#!/bin/bash

# Get player status
status=$(playerctl status 2>/dev/null)

# Exit if no player is running
if [ -z "$status" ]; then
    echo ""
    exit 0
fi

# Exit if status is stopped
if [ "$status" = "Stopped" ]; then
    echo ""
    exit 0
fi

# Get metadata
title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)
player=$(playerctl metadata --format "{{playerName}}" 2>/dev/null)

# Set player icon
case $player in
    "spotify")
        player_icon="󰓇"
        ;;
    "firefox")
        player_icon="󰈹"
        ;;
    *)
        player_icon="󰎆"
        ;;
esac

# Set status icon
if [ "$status" = "Playing" ]; then
    status_icon="󰏤"
    class="playing"
elif [ "$status" = "Paused" ]; then
    status_icon="󰐊"
    class="paused"
else
    echo ""
    exit 0
fi

# Truncate title if too long
max_length=40
if [ ${#title} -gt $max_length ]; then
    title="${title:0:$max_length}..."
fi

# Output JSON for Waybar
echo "{\"text\": \"$player_icon $title - $artist\", \"class\": \"$class\", \"tooltip\": \"$status: $title by $artist\"}"