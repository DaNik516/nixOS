{ delib, ... }:
delib.module {
  name = "nh";
  # Not enabling this module causes some shell aliases to not work
  options = delib.singleEnableOption true;

  nixos.ifEnabled =
    { myconfig, ... }:
    {
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 30d --keep 5"; # If changing the number to keep also make the change in boot.nix;
        flake = "/home/${myconfig.constants.user}/nixOS";
      };
    };
}
