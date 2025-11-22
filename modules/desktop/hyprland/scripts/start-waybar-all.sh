#!/usr/bin/env bash
# Start Waybar on laptop monitor only (default behavior on Wayland)
# Note: Waybar on Wayland/Hyprland shows on primary monitor by default
# Multi-monitor support is limited without creating separate config files

# Kill existing waybar instances
pkill waybar

# Wait a moment
sleep 0.5

# Start a single waybar instance on primary monitor
waybar &

# Note: To show waybar on external monitor, you would need:
# 1. Create separate waybar config with different output
# 2. Or use waybar with proper output configuration
# 3. Or accept that waybar only shows on primary monitor
