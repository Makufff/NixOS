{ host, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) hyprlockWallpaper hyprlockBlur;
in
{
  home-manager.sharedModules = [
    (_: {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
            # Enable keyboard layout switching
            enable_fingerprint = false;
          };

          background = [
            {
              monitor = "";
              color = "rgb(36, 39, 58)";
              path = "${../../../../themes/wallpapers/${hyprlockWallpaper}}";

              new_optimizations = true;
              blur_size = hyprlockBlur or 3;
              blur_passes = 2;
              noise = 0.0117;
              contrast = 1.000;
              brightness = 1.0000;
              vibrancy = 0.2100;
              vibrancy_darkness = 0.0;
            }
          ];

          input-field = [
            {
              monitor = "";
              size = "250, 50";
              outline_thickness = 3;
              outer_color = "rgb(198, 160, 246)";
              inner_color = "rgb(36, 39, 58)";
              font_color = "rgb(198, 160, 246)";
              fail_color = "rgb(237, 135, 150)";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              fail_transition = 300;
              fade_on_empty = false;
              placeholder_text = "Password...";
              dots_size = 0.2;
              dots_spacing = 0.64;
              dots_center = true;
              position = "0, 140";
              halign = "center";
              valign = "bottom";
            }
          ];

          label = [
            {
              monitor = "";
              # text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M:%S\") </big></b>\"";
              text = "$TIME";
              font_size = 64;
              color = "rgb(198, 160, 246)";
              position = "0, 16";
              valign = "center";
              halign = "center";
            }
            {
              monitor = "";
              text = "Hello <span text_transform=\"capitalize\" size=\"larger\">$USER!</span>";
              color = "rgb(198, 160, 246)";
              font_size = 20;
              position = "0, 100";
              halign = "center";
              valign = "center";
            }
            {
              monitor = "";
              text = "Current Layout : $LAYOUT";
              color = "rgb(198, 160, 246)";
              font_size = 14;
              position = "0, 40";
              halign = "center";
              valign = "bottom";
            }
            {
              monitor = "";
              text = "<i>Press Caps Lock or click to switch keyboard layout</i>";
              color = "rgba(198, 160, 246, 0.8)";
              font_size = 12;
              position = "0, 20";
              halign = "center";
              valign = "bottom";
            }
            /*
                 {
                monitor = "";
                text = "Enter your password to unlock.";
                color = "rgb(198, 160, 246)";
                font_size = 14;
                position = "0, 60";
                halign = "center";
                valign = "bottom";
              }
            */
          ];
        };
      };
    })
  ];
}
