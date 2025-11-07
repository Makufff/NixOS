{ pkgs, ... }:

pkgs.writeShellScriptBin "network-reset" ''
  #!/usr/bin/env bash
  
  echo "=== Network Reset Tool ==="
  echo "This will reset all network connections and restart NetworkManager"
  echo
  
  read -p "Continue? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
  fi
  
  echo "1. Stopping NetworkManager..."
  sudo systemctl stop NetworkManager
  
  echo "2. Flushing IP addresses..."
  for iface in $(ip link | grep -E '^[0-9]+:' | cut -d: -f2 | tr -d ' ' | grep -v lo); do
    echo "  Flushing $iface"
    sudo ip addr flush dev "$iface" 2>/dev/null || true
    sudo ip link set "$iface" down 2>/dev/null || true
    sudo ip link set "$iface" up 2>/dev/null || true
  done
  
  echo "3. Clearing DNS cache..."
  sudo systemctl restart systemd-resolved 2>/dev/null || true
  
  echo "4. Restarting NetworkManager..."
  sudo systemctl start NetworkManager
  
  echo "5. Waiting for NetworkManager to start..."
  sleep 5
  
  echo "6. Checking status..."
  nmcli general status
  
  echo
  echo "Network reset complete!"
  echo "Try connecting to your network now."
''