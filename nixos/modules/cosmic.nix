{
  pkgs,
  lib,
  config,
  cosmic, # Injected from variables.nix
  ...
}:
{
  config = lib.mkIf cosmic {
    services.desktopManager.cosmic.enable = true;

    # Disable cosmic-greeter since sddm is used instead.
    services.displayManager.cosmic-greeter.enable = false;

    # 3. System76 Scheduler (Performance)
    # Improves responsiveness on desktop, even for non-System76 hardware.
    services.system76-scheduler.enable = true;

    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
      cosmic-greeter
    ];
  };
}
