{
  flake,
  keyboardLayout,
  keyboardVariant,
  kdeMice,
  kdeTouchpads,
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

    mice = kdeMice;
    touchpads = kdeTouchpads;
  };
}
