#!/bin/bash

# Define icons for notification states
NOTIFICATIONS_ENABLED_ICON="󰂚"
NOTIFICATIONS_DISABLED_ICON="󰂛"

# Check current notification state
if makoctl mode | grep -q "do-not-disturb"; then
    CURRENT_STATE="disabled"
else
    CURRENT_STATE="enabled"
fi

# Toggle state if "toggle" argument is passed
if [[ "$1" == "toggle" ]]; then
    makoctl mode -t do-not-disturb
    # Update state after toggling
    if makoctl mode | grep -q "do-not-disturb"; then
        CURRENT_STATE="disabled"
    else
        CURRENT_STATE="enabled"
    fi
fi

# Output icon based on current state
case "$CURRENT_STATE" in
    "enabled")
        echo "$NOTIFICATIONS_ENABLED_ICON"
        ;;
    "disabled")
        echo "$NOTIFICATIONS_DISABLED_ICON"
        ;;
esac
