{
  username = "makufff"; # auto-set with install.sh, live-install.sh, and rebuild scripts.

  # Desktop Environment
  desktop = "hyprland"; # hyprland, i3-gaps, gnome, plasma6

  # Theme & Appearance
  waybarTheme = "minimal"; # stylish, minimal
  sddmTheme = "custom_theme"; # custom_theme, astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "kurzgesagt.webp"; # Change with SUPER + SHIFT + W
  hyprlockWallpaper = "yns1.jpg";

  # Default Applications
  terminal = "kitty"; # kitty, alacritty
  editor = "nixvim"; # nixvim, vscode, helix, doom-emacs, nvchad, neovim
  browser = "zen"; # zen, firefox, floorp
  tuiFileManager = "yazi"; # yazi, lf
  shell = "zsh"; # zsh, bash
  games = true; # Enable/Disable gaming module

  # Hardware
  hostname = "makufff";
  videoDriver = "nvidia"; # nvidia, amdgpu, intel

  # Localization
  timezone = "Asia/Bangkok";
  locale = "en_US.UTF-8";
  clock24h = true;
  kbdLayout = "us,th";
  kbdVariant = "";
  consoleKeymap = "us";
}
