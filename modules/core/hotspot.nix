{ pkgs, lib, config, ... }:

{
  # Enable AP (Access Point) mode support
  networking.networkmanager.unmanaged = [
    # Don't unmanage any interfaces by default
  ];

  # Install hostapd for creating WiFi hotspots
  environment.systemPackages = with pkgs; [
    hostapd
    dnsmasq
  ];

  # Create a script to easily create WiFi hotspot
  environment.systemPackages = [ 
    (pkgs.writeShellScriptBin "create-hotspot" ''
      #!/usr/bin/env bash
      
      SSID="''${1:-NixOS-Hotspot}"
      PASSWORD="''${2:-12345678}"
      INTERFACE="''${3:-wlp0s20f3}"  # Common WiFi interface name
      
      echo "Creating WiFi hotspot..."
      echo "SSID: $SSID"
      echo "Password: $PASSWORD"
      echo "Interface: $INTERFACE"
      echo
      
      # Create hotspot using NetworkManager
      nmcli device wifi hotspot ifname "$INTERFACE" ssid "$SSID" password "$PASSWORD"
      
      if [ $? -eq 0 ]; then
        echo "✓ Hotspot created successfully!"
        echo "Connect with:"
        echo "  SSID: $SSID"
        echo "  Password: $PASSWORD"
      else
        echo "✗ Failed to create hotspot"
        echo "Available WiFi interfaces:"
        nmcli device | grep wifi
      fi
    '')
    
    (pkgs.writeShellScriptBin "stop-hotspot" ''
      #!/usr/bin/env bash
      
      echo "Stopping WiFi hotspot..."
      
      # Find and stop hotspot connections
      HOTSPOT_CONN=$(nmcli -t -f NAME,TYPE connection show --active | grep ":802-11-wireless" | grep -i hotspot | cut -d: -f1)
      
      if [ -n "$HOTSPOT_CONN" ]; then
        nmcli connection down "$HOTSPOT_CONN"
        echo "✓ Hotspot stopped: $HOTSPOT_CONN"
      else
        echo "ℹ No active hotspot found"
      fi
    '')
  ];
}