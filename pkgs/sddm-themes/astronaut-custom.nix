{ stdenv, sddmAstronaut, customWallpaper ? null }:
stdenv.mkDerivation {
  pname = "sddm-astronaut-custom";
  version = "1.0";
  src = sddmAstronaut;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes/astronaut
    cp -aR $src/* $out/share/sddm/themes/astronaut/
    if [ -n "$customWallpaper" ]; then
      cp $customWallpaper $out/share/sddm/themes/astronaut/Backgrounds/custom-bg.jpg
      sed -i 's|Background=.*|Background="Backgrounds/custom-bg.jpg"|g' $out/share/sddm/themes/astronaut/theme.conf
    fi
  '';
}
