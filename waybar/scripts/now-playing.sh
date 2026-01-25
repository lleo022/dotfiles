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

# Set status icon based on playing/paused
if [ "$status" = "Playing" ]; then
    class="playing"
elif [ "$status" = "Paused" ]; then
    class="paused"
else
    echo ""
    exit 0
fi

# Truncate title if too long
max_length=35
if [ ${#title} -gt $max_length ]; then
    title="${title:0:$max_length}..."
fi

# Output JSON for Waybar (no icon in text, it will be added by format)
echo "{\"text\": \"$title - $artist\", \"class\": \"$class\", \"tooltip\": \"$status: $title by $artist\"}"

