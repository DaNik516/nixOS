{ lib, ... }:
{
  # Use mkDefault so this can be overridden in flake.nix. This avoid double installation warning
  time.timeZone = lib.mkDefault "Europe/Zurich";
}
