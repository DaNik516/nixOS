{
  pkgs,
  lib,
  config,
  catppuccin,
  catppuccinFlavor,
  ...
}:
let
  # Your custom layout tweaks (Fonts, Size, Rounding)
  customLayout = ''
    /* Force Font Family */
    * { font-family: "JetBrains Mono"; }

    /* 1. NOTIFICATION POPUP */
    .notification-row .notification-background { min-width: 30em; }

    /* 2. CONTROL CENTER (Sidebar) */
    .control-center { min-width: 15%; }

    /* 3. TEXT SIZING */
    .notification-content .summary { font-size: 1.5rem; font-weight: bold; }
    .notification-content .body { font-size: 1.1rem; }
    .notification-content .time { font-size: 0.9rem; }

    /* Remove outline */
    .notification-row { outline: none; }
  '';
in
{
  catppuccin.swaync.enable = catppuccin;
  catppuccin.swaync.flavor = catppuccinFlavor;

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      notification-icon-size = 64;
    };

    # 🎨 DYNAMIC STYLE LOGIC
    style =
      if catppuccin then
        # If Catppuccin is ON: Force the theme + layout
        lib.mkForce ''
          @import "${config.catppuccin.sources.swaync}/${catppuccinFlavor}.css";
          ${customLayout}
        ''
      else
        # If Stylix is ON: Keep Stylix colors, just add layout
        lib.mkAfter ''
          ${customLayout}
        '';
  };
}
