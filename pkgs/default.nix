{ host, pkgs, ... }:
{
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  pokego = pkgs.callPackage ./pokego.nix { };
  kawaii-grub-theme = pkgs.callPackage ./kawaii-grub-theme.nix { };
  astronaut-custom = pkgs.callPackage ./sddm-themes/astronaut-custom.nix {
    sddmAstronaut = pkgs.sddm-astronaut;
    customWallpaper = ../modules/themes/wallpapers/${host.sddmWallpaper or "yns4.jpg"};
  };
}
