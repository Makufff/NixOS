#!/usr/bin/env bash
# Auto-apply wallpaper and reload waybar when monitors are connected/disconnected

WALLPAPER_PATH="/nix/store/9izi4ds6s5968ykxzbrv6y4841wi19nm-kurzgesagt.webp"

# Function to apply wallpaper to all monitors
apply_wallpapers() {
    # Wait a bit for monitors to fully initialize
    sleep 1
    
    # Get all monitor names
    monitors=$(hyprctl monitors all -j | jq -r '.[].name')
    
    # Apply wallpaper to each monitor
    for monitor in $monitors; do
        swww img "$WALLPAPER_PATH" --outputs "$monitor" &
    done
    
    wait
}

# Function to reload waybar
reload_waybar() {
    pkill waybar
    sleep 0.5
    waybar &
}

# Listen to monitor connect/disconnect events
handle_monitor_event() {
    case $1 in
        monitoradded*|monitorremoved*)
            echo "Monitor changed: $1"
            apply_wallpapers
            reload_waybar
            ;;
    esac
}

# Apply wallpapers on startup
apply_wallpapers

# Listen to hyprland events
socat -U - UNIX-CONNECT:/run/user/$UID/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r event; do
    handle_monitor_event "$event"
done
