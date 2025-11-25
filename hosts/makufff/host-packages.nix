{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    # pokego # Overlayed
  ];
}
