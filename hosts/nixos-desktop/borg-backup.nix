{
  config,
  pkgs,
  lib,
  ...
}:

let
  # ---------------------------------------------------------
  # 🔧 VARIABLES
  # ---------------------------------------------------------
  nasUser = "krit";
  nasHost = "nicol-nas"; # Tailscale MagicDNS
  nasPath = "/volume1/Default-volume-1/0001_Docker/borgitory/${config.networking.hostName}";

  sshKeyPath = "/etc/nixos/secrets/id_borg_ed25519";
  passphraseFile = "/etc/nixos/secrets/borg-passphrase";
in
{
  services.borgmatic = {
    enable = true;

    configurations = {
      "desktop-data" = {
        location = {
          # Backup the entire home directory...
          source_directories = [ "/home/krit" ];
          repositories = [ "ssh://${nasUser}@${nasHost}${nasPath}" ];

          exclude_patterns = [
            # 1. Standard Heavy Files
            "*.vdi"
            "*.qcow2"
            "*.iso"
            "/home/*/Downloads"
            "/home/*/.local/share/Trash"

            # 2. CACHE (Safe to delete, regenerates automatically)
            "/home/*/.cache"
            "/home/*/.npm" # Node.js cache
            "/home/*/.cargo" # Rust cache
            "/home/*/.m2" # Maven (Java) cache
            "/home/*/.gradle" # Gradle cache
            "/home/*/.mozilla/firefox/*.default-release/cache2" # Firefox Cache

            # 3. ELECTRON JUNK (Inside .config)
            # These apps store massive cache files in their config folders
            "/home/*/.config/discord/Cache"
            "/home/*/.config/discord/Code Cache"
            "/home/*/.config/Code/Cache"
            "/home/*/.config/Code/CachedData"
            "/home/*/.config/Slack/Cache"
            "/home/*/.config/Spotify/PersistentCache"

            # 4. REPOS (Since you have them on GitHub)
            "/home/*/developing-projects"
            "/home/*/dotfiles"
            "/home/*/nixOS"
            "/home/*/progettoFDI"
            "/home/*/tools"
          ];
        };

        storage = {
          encryption_passcommand = "cat ${passphraseFile}";
          compression = "auto,zstd";
          ssh_command = "ssh -i ${sshKeyPath} -o StrictHostKeyChecking=no";
        };

        retention = {
          keep_daily = 7;
          keep_weekly = 4;
          keep_monthly = 6;
        };

        consistency = {
          checks = [
            "repository"
            "archives"
          ];
          check_last = 3;
        };
      };
    };
  };

  # Run daily at 18:00, or immediately if computer was off
  systemd.timers.borgmatic = {
    timerConfig = {
      OnCalendar = "18:00";
      Persistent = true;
      RandomizedDelaySec = "5m";
    };
  };

  # Enable Tailscale so we can reach the NAS
  services.tailscale.enable = true;
}
