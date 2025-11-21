#!/usr/bin/env bash
# Display mode switcher for Hyprland
# Supports: extend, duplicate (mirror), and laptop-only modes

STATE_FILE="/tmp/hyprland-display-mode"

# Get list of connected monitors
get_monitors() {
    hyprctl monitors -j | jq -r '.[].name'
}

# Get primary (laptop) monitor
get_primary() {
    # Usually eDP-1 or similar for laptop screens
    hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP") or startswith("LVDS")) | .name' | head -n 1
}

# Get external monitor
get_external() {
    primary=$(get_primary)
    hyprctl monitors -j | jq -r ".[] | select(.name != \"$primary\") | .name" | head -n 1
}

# Get current mode from state file
get_current_mode() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "extend"  # default mode
    fi
}

# Set extend mode (side-by-side)
set_extend() {
    primary=$(get_primary)
    external=$(get_external)
    
    if [ -z "$external" ]; then
        notify-send "Display" "No external monitor detected" -i video-display
        return 1
    fi
    
    # Get primary monitor resolution
    primary_width=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$primary\") | .width")
    
    # Position external monitor to the right of primary
    hyprctl keyword monitor "$external,preferred,${primary_width}x0,1"
    hyprctl keyword monitor "$primary,preferred,0x0,1"
    
    echo "extend" > "$STATE_FILE"
    notify-send "Display Mode" "Extended (side-by-side)" -i video-display
}

# Set duplicate/mirror mode
set_duplicate() {
    primary=$(get_primary)
    external=$(get_external)
    
    if [ -z "$external" ]; then
        notify-send "Display" "No external monitor detected" -i video-display
        return 1
    fi
    
    # Mirror primary on external
    hyprctl keyword monitor "$external,preferred,0x0,1,mirror,$primary"
    
    echo "duplicate" > "$STATE_FILE"
    notify-send "Display Mode" "Duplicate (mirrored)" -i video-display
}

# Set laptop-only mode (disable external)
set_laptop_only() {
    primary=$(get_primary)
    external=$(get_external)
    
    if [ -z "$external" ]; then
        notify-send "Display" "Already in laptop-only mode" -i video-display
        return 1
    fi
    
    # Disable external monitor
    hyprctl keyword monitor "$external,disable"
    hyprctl keyword monitor "$primary,preferred,0x0,1"
    
    echo "laptop" > "$STATE_FILE"
    notify-send "Display Mode" "Laptop only" -i video-display
}

# Set external-only mode (disable laptop screen)
set_external_only() {
    primary=$(get_primary)
    external=$(get_external)
    
    if [ -z "$external" ]; then
        notify-send "Display" "No external monitor detected" -i video-display
        return 1
    fi
    
    # Disable laptop screen
    hyprctl keyword monitor "$primary,disable"
    hyprctl keyword monitor "$external,preferred,0x0,1"
    
    echo "external" > "$STATE_FILE"
    notify-send "Display Mode" "External only" -i video-display
}

# Toggle between modes (for keybind)
toggle_mode() {
    current=$(get_current_mode)
    
    case "$current" in
        extend)
            set_duplicate
            ;;
        duplicate)
            set_laptop_only
            ;;
        laptop)
            set_external_only
            ;;
        external)
            set_extend
            ;;
        *)
            set_extend
            ;;
    esac
}

# Cycle through common modes (for Waybar click)
cycle_mode() {
    current=$(get_current_mode)
    
    case "$current" in
        extend)
            set_duplicate
            ;;
        duplicate)
            set_extend
            ;;
        *)
            set_extend
            ;;
    esac
}

# Get status for Waybar
get_status() {
    external=$(get_external)
    
    if [ -z "$external" ]; then
        echo '{"text": "󰍹", "tooltip": "Laptop only (no external)", "class": "single"}'
        return
    fi
    
    current=$(get_current_mode)
    
    case "$current" in
        extend)
            echo '{"text": "󰍹󰍹", "tooltip": "Extended display", "class": "extend"}'
            ;;
        duplicate)
            echo '{"text": "󰍺", "tooltip": "Duplicate (mirrored)", "class": "duplicate"}'
            ;;
        laptop)
            echo '{"text": "󰍹", "tooltip": "Laptop only", "class": "single"}'
            ;;
        external)
            echo '{"text": "󰍹", "tooltip": "External only", "class": "single"}'
            ;;
        *)
            echo '{"text": "󰍹", "tooltip": "Unknown mode", "class": "single"}'
            ;;
    esac
}

# Main command dispatcher
case "$1" in
    extend)
        set_extend
        ;;
    duplicate|mirror)
        set_duplicate
        ;;
    laptop|laptop-only)
        set_laptop_only
        ;;
    external|external-only)
        set_external_only
        ;;
    toggle)
        toggle_mode
        ;;
    cycle)
        cycle_mode
        ;;
    status)
        get_status
        ;;
    *)
        echo "Usage: $0 {extend|duplicate|laptop-only|external-only|toggle|cycle|status}"
        echo ""
        echo "Modes:"
        echo "  extend        - Side-by-side (laptop + external)"
        echo "  duplicate     - Mirror/duplicate screens"
        echo "  laptop-only   - Disable external monitor"
        echo "  external-only - Disable laptop screen"
        echo "  toggle        - Cycle through all modes"
        echo "  cycle         - Cycle between extend/duplicate"
        echo "  status        - Get JSON status for Waybar"
        exit 1
        ;;
esac
