{
  lib,
  pkgs,
  cosmic,
  ...
}:
{
  config = lib.mkIf cosmic {
    # Enable to allow cliphist to work
    home.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
  };
}
