{
  # ---------------------------------------------------------
  # ⚙️ SYSTEM CORE
  # ---------------------------------------------------------
  # Import all your hardware/system configs here.
  # ❌ DO NOT import ./hyprland, ./gnome, or ./kde here (they are managed based on flake.nix)
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./env.nix
    ./guest.nix
    ./home-manager.nix
    ./kernel.nix
    ./mime.nix
    ./net.nix
    ./nh.nix
    ./nix.nix
    ./sddm.nix
    ./timezone.nix
    ./user.nix
    ./zram.nix
  ];
}
