{
  pkgs,
  lib,
  config,
  wallpapers,
  catppuccin,
  catppuccinFlavor,
  catppuccinAccent,
  polarity,
  base16Theme,
  ...
}:
let
  firstWallpaper = builtins.head wallpapers;
  wallpaperPath = pkgs.fetchurl {
    url = firstWallpaper.wallpaperURL;
    sha256 = firstWallpaper.wallpaperSHA256;
  };

  colorScheme = if polarity == "dark" then "prefer-dark" else "prefer-light";
  iconThemeName = if polarity == "dark" then "Papirus-Dark" else "Papirus-Light";
in
{
  home.packages =
    (lib.optionals catppuccin [
      (pkgs.catppuccin-gtk.override {
        accents = [ catppuccinAccent ];
        size = "standard";
        tweaks = [
          "rimless"
          "black"
        ];
        variant = catppuccinFlavor;
      })
    ])
    ++ [
      pkgs.papirus-icon-theme
      pkgs.hydrapaper
    ];

  dconf.settings = {

    # --- INTERFACE & THEME ---
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkForce colorScheme;
      icon-theme = iconThemeName;
    };

    # --- WALLPAPER ---
    "org/gnome/desktop/background" = {
      picture-uri = "file://${wallpaperPath}";
      picture-uri-dark = "file://${wallpaperPath}";
      picture-options = lib.mkForce "zoom";
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${wallpaperPath}";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
  };
}
