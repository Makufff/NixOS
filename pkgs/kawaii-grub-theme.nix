{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "kawaii-grub-theme";
  version = "1.0.0";

  src = ./kawaii-grub-theme;

  installPhase = ''
    # Create output directory
    mkdir -p $out
    
    # Copy all theme files
    cp -r * $out/
    
    # Ensure proper permissions
    chmod -R 755 $out
  '';

  meta = with pkgs.lib; {
    description = "Kawaii GRUB Theme - Cute anime-style bootloader theme";
    homepage = "https://makufff.dev/kawaii-grub-theme/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
