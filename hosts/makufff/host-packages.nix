{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    protonvpn-gui # VPN
    github-desktop
    vscode
    teams-for-linux
    # pokego # Overlayed
  ];
}
