{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    ( [
      obsidian
      protonvpn-gui # VPN
      github-desktop
      vscode
      teams-for-linux
      pkg-config
      wayland
      wayland-protocols
      libxkbcommon
      xorg.libX11
      wireshark
      wireshark-qt
      code-cursor
      # pokego # Overlayed
      postman
      ciscoPacketTracer8  # Cisco Packet Tracer 8
      tor-browser
      gparted
      gns3-gui
      gns3-server
      dynamips
      ubridge
      vpcs
    ] ++ (if builtins.hasAttr "prismlauncher" pkgs then [ pkgs.prismlauncher ] else []));
}
