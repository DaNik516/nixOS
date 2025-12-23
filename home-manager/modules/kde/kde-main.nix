{
  pkgs,
  lib,
  wallpapers,
  config,
  catppuccin,
  catppuccinFlavor,
  catppuccinAccent,
  ...
}:
let
  wallpaperFiles = builtins.map (
    wp:
    "${pkgs.fetchurl {
      url = wp.wallpaperURL;
      sha256 = wp.wallpaperSHA256;
    }}"
  ) wallpapers;

  polarity = config.stylix.polarity;

  capitalize =
    s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (builtins.stringLength s) s;

  theme =
    if catppuccin then
      "Catppuccin${capitalize catppuccinFlavor}${capitalize catppuccinAccent}"
    else if polarity == "dark" then
      "BreezeDark"
    else
      "BreezeLight";

  lookAndFeel =
    if catppuccin then
      "org.kde.breezedark.desktop"
    else if polarity == "dark" then
      "org.kde.breezedark.desktop"
    else
      "org.kde.breeze.desktop";

  cursorTheme = config.stylix.cursor.name;
in
{
  programs.plasma = {
    enable = true;

    overrideConfig = lib.mkForce true;

    workspace = {
      clickItemTo = "select"; # Require double click to open items

      colorScheme = theme;
      lookAndFeel = lookAndFeel;
      cursor.theme = cursorTheme;
      wallpaper = wallpaperFiles;
    };

    configFile = {
      "kdeglobals"."KDE"."widgetStyle" = if catppuccin then "kvantum" else "Breeze";
      "kdeglobals"."General"."AccentColor" = if catppuccin then "203,166,247" else null; # Manual mauve fallback
    };
  };

  # Packages that one only want in kde sessions
  home.packages = with pkgs.kdePackages; [
    kcalc
    kcolorchooser
    elisa
    gwenview
    okular
    konsole

    # Theme packages (necessary)
    pkgs.catppuccin-kde
    pkgs.catppuccin-kvantum
  ];
}
