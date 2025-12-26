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

        # 1. Sources & Destinations
        source_directories = [ "/home/krit" ];

        repositories = [
          {
            path = "ssh://${nasUser}@${nasHost}${nasPath}";
            label = "nas-repo";
          }
        ];

        # 2. Exclusions
        exclude_patterns = [
          # Standard Heavy Files
          "*.vdi"
          "*.qcow2"
          "*.iso"
          "/home/*/Downloads"
          "/home/*/.local/share/Trash"

          # CACHE
          "/home/*/.cache"
          "/home/*/.npm"
          "/home/*/.cargo"
          "/home/*/.m2"
          "/home/*/.gradle"
          "/home/*/.mozilla/firefox/*.default-release/cache2"

          # ELECTRON JUNK
          "/home/*/.config/discord/Cache"
          "/home/*/.config/discord/Code Cache"
          "/home/*/.config/Code/Cache"
          "/home/*/.config/Code/CachedData"
          "/home/*/.config/Slack/Cache"
          "/home/*/.config/Spotify/PersistentCache"

          # REPOS
          "/home/*/developing-projects"
          "/home/*/dotfiles"
          "/home/*/nixOS"
          "/home/*/progettoFDI"
          "/home/*/tools"
        ];

        # 3. Storage & Encryption
        encryption_passcommand = "cat ${passphraseFile}";
        compression = "auto,zstd";
        ssh_command = "ssh -i ${sshKeyPath} -o StrictHostKeyChecking=no";

        # 4. Retention (Keep Policy)
        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;

        # 5. Consistency Checks
        checks = [
          { name = "repository"; }
          { name = "archives"; }
        ];
        check_last = 3;
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
