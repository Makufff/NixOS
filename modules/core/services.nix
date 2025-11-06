{ pkgs, ... }:
{
  # Services to start
  services = {
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    devmon.enable = true; # For Mounting USB & More
    gvfs.enable = true; # For Mounting USB & More
    udisks2.enable = true; # For Mounting USB & More

    # Userspace CPU Scheduler for Improved Latency for Gaming (Hardware Specific)
    # services.scx = {
    #   enable = true;
    #   package = pkgs.scx.rustscheds;
    #   scheduler = "scx_lavd"; # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
    # };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview

    # Tailscale VPN
    tailscale.enable = true;

    # OpenVPN
    openvpn.servers = {
      # Example server config - uncomment and configure as needed
      # myVPN = {
      #   config = '' config /path/to/your/config.ovpn '';
      #   autoStart = false;
      # };
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      
      # Simple wireplumber config (Ubuntu style)
      wireplumber.enable = true;
      
      # # Ubuntu-style: Simple and stable audio settings
      # extraConfig.pipewire."92-low-latency" = {
      #   "context.properties" = {
      #     "default.clock.rate" = 48000;
      #     "default.clock.quantum" = 1024;
      #     "default.clock.min-quantum" = 512;
      #     "default.clock.max-quantum" = 2048;
      #   };
      # };
      
      # extraConfig.pipewire-pulse."92-low-latency" = {
      #   "pulse.properties" = {
      #     "pulse.min.req" = "1024/48000";
      #     "pulse.default.req" = "1024/48000";
      #     "pulse.max.req" = "2048/48000";
      #     "pulse.min.quantum" = "1024/48000";
      #     "pulse.max.quantum" = "2048/48000";
      #   };
      #   "stream.properties" = {
      #     "resample.quality" = 10;
      #   };
      # };
    };
  };
}
