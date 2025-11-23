{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sddmTheme;
  
  # Custom SDDM theme with custom wallpaper
  sddm-custom = pkgs.stdenv.mkDerivation {
    pname = "sddm-astronaut-custom";
    version = "1.0";
    src = pkgs.sddm-astronaut;
    
    buildInputs = [ pkgs.rsync ];
    
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
      
      # Replace astronaut wallpaper with custom one
      cp ${../themes/wallpapers/yns4.jpg} $out/Backgrounds/yns4.jpg
      
      # Update theme.conf for astronaut theme to use custom background
      if [ -f "$out/Themes/astronaut/theme.conf" ]; then
        sed -i 's|Background=.*|Background="Backgrounds/yns4.jpg"|g' $out/Themes/astronaut/theme.conf
      fi
    '';
  };
  
  sddm-astronaut = (if sddmTheme == "astronaut" then sddm-custom else pkgs.sddm-astronaut).override {
    embeddedTheme = "${sddmTheme}";
    themeConfig =
      if lib.hasSuffix "custom_theme" sddmTheme then
        {
          ScreenPadding = "";
          FormPosition = "left"; # left, center, right
          PartialBlur = "false";
        }
      else if lib.hasSuffix "black_hole" sddmTheme then
        {
          ScreenPadding = "";
          FormPosition = "center"; # left, center, right
        }
      else if lib.hasSuffix "astronaut" sddmTheme then
        {
          PartialBlur = "false";
          FormPosition = "center"; # left, center, right
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
