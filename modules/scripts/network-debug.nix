{ pkgs, ... }:

pkgs.writeShellScriptBin "network-debug" ''
  #!/usr/bin/env bash
  
  echo "=== Network Debug Information ==="
  echo
  
  echo "1. Network Interfaces:"
  ip link show
  echo
  
  echo "2. IP Addresses:"
  ip addr show
  echo
  
  echo "3. Routing Table:"
  ip route show
  echo
  
  echo "4. DNS Configuration:"
  cat /etc/resolv.conf
  echo
  
  echo "5. NetworkManager Status:"
  nmcli general status
  echo
  
  echo "6. WiFi Status:"
  nmcli device wifi list
  echo
  
  echo "7. Connection Status:"
  nmcli connection show --active
  echo
  
  echo "8. Connectivity Test:"
  echo "Testing connectivity to:"
  for host in google.com cloudflare.com 8.8.8.8 1.1.1.1; do
    echo -n "  $host: "
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
      echo "✓ OK"
    else
      echo "✗ FAILED"
    fi
  done
  echo
  
  echo "9. DNS Resolution Test:"
  for domain in google.com github.com; do
    echo -n "  $domain: "
    if nslookup "$domain" >/dev/null 2>&1; then
      echo "✓ OK"
    else
      echo "✗ FAILED"
    fi
  done
  echo
  
  echo "10. ModemManager Status (if available):"
  if command -v mmcli >/dev/null 2>&1; then
    mmcli -L 2>/dev/null || echo "No modems found"
  else
    echo "ModemManager not available"
  fi
  echo
  
  echo "Debug complete!"
''