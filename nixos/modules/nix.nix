{
  # -----------------------------------------------------------------------
  # ⚙️ PROGRAM: NIX SETTINGS
  # -----------------------------------------------------------------------

  nix.settings = {
    # Enable Flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # 🚀 HYPRLAND CACHE (Stops compiling from source)
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
