{
  # ---------------------------------------------------------------------------
  # 🖥️ HYPRLAND WORKSPACES
  # ---------------------------------------------------------------------------
  # Strict monitor bindings for my main PC.
  # If you remove this, Hyprland will auto-detect monitors based on mouse focus.
  hyprlandWorkspaces = [
    "1, monitor:DP-1"
    "2, monitor:DP-1"
    "3, monitor:DP-1"
    "4, monitor:DP-1"
    "5, monitor:DP-1"
    "6, monitor:DP-2"
    "7, monitor:DP-2"
    "8, monitor:DP-2"
    "9, monitor:DP-2"
    "10, monitor:DP-2"
  ];

  # ---------------------------------------------------------------------------
  # 🖱️ KDE INPUT DEVICES
  # ---------------------------------------------------------------------------
  # Strict hardware IDs for Plasma Manager.
  # If you remove this, KDE will use default plug-and-play settings.
  kdeMice = [
    {
      enable = true;
      name = "Logitech G403";
      vendorId = "046d"; # Logitech
      productId = "c08f"; # G403
      acceleration = -1.0;
      accelerationProfile = "none";
    }
  ];

  # Leave empty for desktop PCs
  kdeTouchpads = [ ];

  # ---------------------------------------------------------------------------
  # 🧩 WAYBAR WORKSPACE ICONS
  # ---------------------------------------------------------------------------
  # Define custom icons for specific workspace numbers.
  # If you remove this, Waybar will just show numbers (1, 2, 3...)
  waybarWorkspaceIcons = {
    "1" = "";
    "2" = "";
    "3" = "";
    "4" = "";
    "5" = "";
    "6" = "";
    "7" = ":"; # Chrome/Browser
    "8" = ":"; # Terminal
    "9" = ":"; # Music
    "10" = ":"; # Chat
    "magic" = ":";
  };

  waybarLayoutFlags = {
    "format-en" = "🇺🇸";
    "format-it" = "🇮🇹";
    "format-de" = "🇩🇪";
    "format-fr" = "🇫🇷";
  };

  starshipZshIntegration = false;

  nixImpure = true;
}
