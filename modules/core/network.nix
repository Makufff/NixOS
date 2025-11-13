{ host, pkgs, lib , ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{
  # Enable additional networking features
  networking.wireless.enable = false; # Disable wpa_supplicant in favor of NetworkManager
  networking = {
    hostName = "${hostname}";
    networkmanager = {
      enable = true;
      # Use systemd-resolved for DNS (force to override conflicts)
      dns = lib.mkForce "systemd-resolved";
      # Enable WiFi powersave (can be disabled if causing connection issues)
      wifi.powersave = false;
      # Scan WiFi more frequently for better connection
      wifi.scanRandMacAddress = true;
    };
    # Fallback DNS servers
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" "10.253.192.1"];
    # Enable DHCP on all interfaces by default
    useDHCP = lib.mkDefault true;
    # Extra hosts for internal domains
    extraHosts = ''
      10.30.32.15 pve-1.it.kmitl.ac.th
    '';
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    firewall = {
      enable = true;
      # Allow common connectivity ports
      allowedTCPPorts = [
        22 # SSH (Secure Shell) - remote access
        80 # HTTP - web traffic
        443 # HTTPS - encrypted web traffic
        53 # DNS over TCP
        1194 # OpenVPN default port
        3389 # RDP (Remote Desktop Protocol)
        59010 # Custom application port
        59011 # Custom application port
        8080 # Alternative HTTP/web server port
        8006 # Proxmox VE web interface
      ];
      allowedUDPPorts = [
        53 # DNS
        67 # DHCP server
        68 # DHCP client
        1194 # OpenVPN default port
        59010 # Custom application port
        59011 # Custom application port
      ];
      # Allow ping for network diagnostics
      allowPing = true;
      # Log refused connections for debugging
      logRefusedConnections = false;
    };
    localCommands = ''
      WANIF="eno1"

      # Exit early if the specified network interface does not exist
      ${pkgs.iproute2}/bin/ip link show "$WANIF" > /dev/null 2>&1 || exit 0

      # Remove any existing qdiscs on WAN interface and ifb0 to avoid conflicts
      ${pkgs.iproute2}/bin/tc qdisc del dev "$WANIF" root || true
      ${pkgs.iproute2}/bin/tc qdisc del dev ifb0 root || true

      # Create the ifb0 interface if it does not exist (used for ingress traffic shaping)
      ${pkgs.iproute2}/bin/ip link show ifb0 > /dev/null 2>&1 || \
        ${pkgs.iproute2}/bin/ip link add name ifb0 type ifb
      ${pkgs.iproute2}/bin/ip link set dev ifb0 up

      # Apply Cake queuing discipline on the WAN interface for upload shaping
      # Options:
      # - bandwidth: set maximum upload bandwidth limit
      # - diffserv4: enable DiffServ for QoS marking support
      # - triple-isolate: isolate flows between local, ingress, and egress
      # - nat: improve NAT handling for better fairness
      # - wash: normalize DSCP markings
      # - ack-filter: filter TCP ACK packets to reduce unnecessary traffic
      # - overhead: account for protocol overhead in shaping calculations
      ${pkgs.iproute2}/bin/tc qdisc add dev "$WANIF" root cake \
        diffserv4 triple-isolate nat wash ack-filter overhead 50

      # Add ingress qdisc on WAN interface to redirect ingress traffic to ifb0
      ${pkgs.iproute2}/bin/tc qdisc add dev "$WANIF" handle ffff: ingress

      # Redirect all incoming IP traffic from WAN interface to ifb0 for download shaping
      ${pkgs.iproute2}/bin/tc filter add dev "$WANIF" parent ffff: protocol ip u32 match u32 0 0 \
        flowid 1:1 action mirred egress redirect dev ifb0

      # Apply Cake queuing discipline on ifb0 interface for download shaping
      # Same options as upload shaping, but without 'nat' as it's unnecessary here
      ${pkgs.iproute2}/bin/tc qdisc add dev ifb0 root cake \
        diffserv4 triple-isolate nat wash overhead 50
    '';
  };

  # NetworkManager VPN plugins for various connection types
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn     # OpenVPN support
    networkmanager-openconnect # Cisco AnyConnect/ocserv support
    networkmanager-vpnc        # Cisco VPN support
    networkmanager-l2tp        # L2TP VPN support
    networkmanager-fortisslvpn # FortiSSL VPN support
    networkmanager-strongswan  # IPSec/IKEv2 VPN support (replaces enableStrongSwan)
  ];

  # WiFi and network utilities
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # GUI for NetworkManager
    # modemmanager        # Mobile broadband support (disabled for now)
    # usb-modeswitch      # USB modem mode switching (disabled for now)
    iproute2            # Network configuration tools
    wirelesstools       # WiFi tools (iwconfig, iwlist) - corrected package name
    wpa_supplicant      # WiFi authentication
    ethtool            # Ethernet diagnostics
    tcpdump            # Network packet analyzer
    nmap               # Network scanner
    wget               # File downloader
    curl               # HTTP client
    dig                # DNS lookup
    whois              # Domain information
    traceroute         # Network path tracing
    iperf3             # Network performance testing
    dnsutils           # Additional DNS tools
    net-tools          # Classic network tools (ifconfig, netstat)
    bridge-utils       # Network bridge utilities
  ];

}
