{ delib
, lib
, ...
}:
delib.module {
  name = "boot";

  nixos.always = {
    boot.plymouth.enable = true;
    boot.kernelParams = [ "quiet" "splash" ];

    boot.loader = {
      timeout = 30;
      efi.canTouchEfiVariables = true;

      systemd-boot.enable = lib.mkForce false;

      grub = {
        enable = lib.mkForce true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "3840x2160,2560x1440,1920x1080,1024x768,auto";
        gfxpayloadEfi = "text";

        configurationLimit = 5; # If changing the number to keep also make the change in nh.nix;
        extraEntries = ''
          menuentry "UEFI Firmware Settings" {
            fwsetup
          }
        '';
      };
    };
  };
}
