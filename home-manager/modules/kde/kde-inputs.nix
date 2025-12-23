{
  flake,
  keyboardLayout,
  keyboardVariant,
  ...
}:
{
  programs.plasma.input = {
    # 1. KEYBOARD
    keyboard = {
      layouts = [
        {
          layout = keyboardLayout;
          variant = keyboardVariant;
        }
      ];
      numlockOnStartup = "on";
    };

    # 2. MOUSE
    mice = [
      {
        enable = true;
        name = "Logitech G403";
        vendorId = "046d"; # Required (Logitech ID)
        productId = "c08f"; # Required (Logitech G403 ID)
        acceleration = -1.0;
        accelerationProfile = "none";
      }
    ];

    touchpads = [ ];
  };
}
