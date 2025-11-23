{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sddmTheme;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "${sddmTheme}";
    themeConfig =
      if lib.hasSuffix "custom_theme" sddmTheme then
        {
          ScreenPadding = "";
          FormPosition = "left";
          PartialBlur = "false";
        }
      else if lib.hasSuffix "black_hole" sddmTheme then
        {
          ScreenPadding = "";
          FormPosition = "center";
        }
      else if lib.hasSuffix "astronaut" sddmTheme then
        {
          PartialBlur = "false";
          FormPosition = "center";
        }
      else if lib.hasSuffix "purple_leaves" sddmTheme then
        {
          PartialBlur = "false";
        }
      else
        { };
  };
  sddmDependencies = [
        sddm-astronaut
        pkgs.kdePackages.qtsvg # Sddm Dependency
        pkgs.kdePackages.qtmultimedia # Sddm Dependency
        pkgs.kdePackages.qtvirtualkeyboard # Sddm Dependency
      ];
in
{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      autoNumlock = true;
      package = lib.mkForce pkgs.kdePackages.sddm;
      extraPackages = sddmDependencies;
      settings = {
        Theme.CursorTheme = "Bibata-Modern-Classic";
        # Enable keyboard layout switching
        General = {
          InputMethod = "";
        };
        X11 = {
          DisplayCommand = "${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout us,th -option grp:caps_toggle";
          DisplayStopCommand = "";
        };
      };
      theme = "sddm-astronaut-theme";
    };
  };

  environment.systemPackages = sddmDependencies;
}
