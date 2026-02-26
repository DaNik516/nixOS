{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "dani.services.laptop.flatpak";
  options.dani.services.laptop.flatpak.enable = delib.boolOption false;

  nixos.always = {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  };

  nixos.ifEnabled = {
    services.flatpak = {
      enable = true;
      packages = [
        "com.jetbrains.IntelliJ-IDEA-Ultimate"
      ];
      update.onActivation = false;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };
  };
}
