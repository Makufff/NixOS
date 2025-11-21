{ pkgs, ... }:
let
  # Use webstorm if available in this nixpkgs, otherwise fall back to jetbrains-toolbox
  webstormPkg = if builtins.hasAttr "webstorm" pkgs then pkgs.webstorm else pkgs.jetbrains-toolbox;
in
{
  # TODO: review
  programs = {
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    hyprlock.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "mbedtls-2.28.10"
  ];

  environment.systemPackages = with pkgs; [
    appimage-run # Needed For AppImage Support
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    gnome-disk-utility # Disk Partitioning and Mounting Utility
    jq # Json Formatting Utility
    bibata-cursors
    sddm-astronaut # Sddm Theme (Overlayed)
    kdePackages.qtsvg # Sddm Dependency
    kdePackages.qtmultimedia # Sddm Dependency
    kdePackages.qtvirtualkeyboard # Sddm Dependency
    fzf # Fuzzy Finder
    fd # Better Find
    git # Git
    gh # Github Authentication Client
  google-chrome # Google Chrome browser
    libjxl # Support for JXL Images
    microfetch # Small fetch (Blazingly fast)
    nix-prefetch-scripts # Find Hashes/Revisions of Nix Packages
    ripgrep # Improved Grep
    tldr # Improved Man
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    pavucontrol # For Editing Audio Levels & Devices
    openvpn3 # OpenVPN 3 Client
    openvpn  # OpenVPN 2 Client (for direct VPN connections)
    dbeaver-bin # Universal Database Tool
      # RDP (Remote Desktop)
    xrdp            # RDP server
    remmina         # Remote desktop client (supports RDP, VNC, SSH)
    freerdp         # RDP client (command-line / cli libs)
    # Python tools (use manual conda install or python3 + venv)
    python3         # Python 3 interpreter
    python3Packages.pip
    python3Packages.virtualenv
  # JetBrains IDEs
  webstormPkg      # WebStorm if available, otherwise JetBrains Toolbox fallback
  jetbrains-toolbox # Optional: JetBrains Toolbox for managing JetBrains IDEs
  # Docker packages
  docker       # Docker daemon + CLI
  docker-compose # Docker Compose (v1/v2 wrapper if available)
  vmware-workstation # VMware Workstation (host application)
    # Virtualisation / VM tools
    qemu_kvm # QEMU KVM hypervisor
    libvirt # libvirt management tools (includes virt-install)
    virt-manager # GUI manager for virtual machines
    libguestfs # Tools for manipulating guest filesystem images
    # aider-chat # AI in terminal (Optional: Client only)
    # cmatrix # Matrix Movie Effect In Terminal
    # cowsay # Great Fun Terminal Program
    # duf # Utility For Viewing Disk Usage In Terminal
    # dysk # Disk space util nice formattting
    # ffmpeg # Terminal Video / Audio Editing
    # gemini-cli # CLI AI client ONLY (optional)
    # glxinfo # needed for inxi diag util
    # inxi # CLI System Information Tool
    # libsForQt5.qt5.qtgraphicaleffects # Sddm Dependency (Old)
    # libnotify # For Notifications
    # lolcat # Add Colors To Your Terminal Command Output
    # lshw # Detailed Hardware Information
    # mpv # Incredible Video Player
    # ncdu # Disk Usage Analyzer With Ncurses Interface
    # nixfmt-rfc-style # Nix Formatter
    # nwg-displays # configure monitor configs via GUI
    # onefetch # provides zsaneyos build info on current system
    # pavucontrol # For Editing Audio Levels & Devices
    # pciutils # Collection Of Tools For Inspecting PCI Devices
    # picard # For Changing Music Metadata & Getting Cover Art
    # pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    # rhythmbox # audio player
    # socat # Needed For Screenshots
    # usbutils # Good Tools For USB Devices
    # uwsm # Universal Wayland Session Manager (optional must be enabled)
    # v4l-utils # Used For Things Like OBS Virtual Camera
    # warp-terminal # Terminal with AI support build in
    # waypaper # Change wallpaper
    # wget # Tool For Fetching Files With Links
    # ytmdl # Tool For Downloading Audio From YouTube

    # devenv
    # devbox
    # shellify
  ];
}
