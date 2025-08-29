#!/bin/bash

# Define icons for each profile
POWER_SAVING_ICON=" 󰁺 " 
BALANCED_ICON=" 󰂀 "
PERFORMANCE_ICON=" 󰁹 "
# Get current profile
CURRENT_PROFILE=$(powerprofilesctl get)

# Toggle profiles if "toggle" argument is passed
if [[ "$1" == "toggle" ]]; then
  case "$CURRENT_PROFILE" in
    "power-saver")
      powerprofilesctl set balanced
      ;;
    "balanced")
      powerprofilesctl set performance
      ;;
    "performance")
      powerprofilesctl set power-saver
      ;;
  esac
fi

# Update icon based on current profile
case "$CURRENT_PROFILE" in
  "power-saver")
    echo "$POWER_SAVING_ICON"
    ;;
  "balanced")
    echo "$BALANCED_ICON"
    ;;
  "performance")
    echo "$PERFORMANCE_ICON"
    ;;
esac
