#!/bin/bash

# Sway autostart script
# Make this file executable: chmod +x autostart.sh

# Kill existing instances
killall waybar 2>/dev/null
killall wbg 2>/dev/null

# Set wallpaper
wbg ~/.config/hypr/wallpaper.jpg &

# Start waybar
waybar &

# Start other utilities (replacements for Hyprland-specific apps)
# elephant replacement - you may need to install or configure an alternative
# hyprsunset replacement - you can use gammastep or similar
# gammastep -l 0:0 -t 6500:3000 &

# Start notification daemon if not running
if ! pgrep -x "mako" > /dev/null; then
    mako &
fi

# Start polkit agent if needed
if ! pgrep -x "polkit-gnome-authentication-agent-1" > /dev/null; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi

# Other autostart applications can be added here
