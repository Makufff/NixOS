{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sddmTheme sddmWallpaper;
  
  # Path to custom wallpaper - easily changeable via variables.nix
  customWallpaper = ../themes/wallpapers/${sddmWallpaper};
  
  sddm-astronaut = pkgs.sddm-astronaut;
  
  # Wrap sddm-astronaut to replace wallpaper if using astronaut theme
  sddm-with-custom-bg = if sddmTheme == "astronaut" then
    pkgs.runCommand "sddm-astronaut-custom-bg" {} ''
      mkdir -p $out
      cp -r ${sddm-astronaut}/* $out/
      chmod -R +w $out
      
      # Create Backgrounds directory and copy custom wallpaper
      mkdir -p $out/Backgrounds
      cp ${customWallpaper} $out/Backgrounds/custom-bg.jpg
      
      # Update theme.conf to use custom background
      if [ -f "$out/Themes/astronaut/theme.conf" ]; then
        sed -i 's|Background=.*|Background="Backgrounds/custom-bg.jpg"|g' $out/Themes/astronaut/theme.conf
      fi
    ''
  else
    sddm-astronaut;
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
