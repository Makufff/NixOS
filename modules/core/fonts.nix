{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # Nerd Fonts
      maple-mono.NF
      pkgs.nerd-fonts.jetbrains-mono

      # Normal Fonts
      noto-fonts
      noto-fonts-color-emoji
      bai-jamjuree
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Maple Mono NF"
          "Noto Mono"
          "DejaVu Sans Mono" # Default
        ];
        sansSerif = [
          "Bai Jamjuree"
          "Noto Sans"
          "DejaVu Sans" # Default
        ];
        serif = [
          "Bai Jamjuree"
          "Noto Serif"
          "DejaVu Serif" # Default
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
