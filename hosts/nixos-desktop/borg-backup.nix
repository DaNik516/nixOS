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
          # 1. STANDARD HEAVY FILES
          "*.vdi"
          "*.qcow2"
          "*.iso"
          "/home/*/Downloads"
          "/home/*/.local/share/Trash"
          "/home/*/.local/share/recent-documents"

          # 2. CLIPBOARD & DOCS
          "/home/*/.local/share/klipper" # Clipboard History
          "/home/*/.local/share/Zeal" # Documentation Sets

          # 3. TELEGRAM JUNK (Keep login, remove temp)
          "/home/*/.local/share/TelegramDesktop/tdata/emoji"
          "/home/*/.local/share/TelegramDesktop/tdata/temp"
          "/home/*/.local/share/TelegramDesktop/tdata/dumps"

          # 4. BROWSERS (Synced)
          "/home/*/.mozilla"
          "/home/*/.config/google-chrome"
          "/home/*/.config/chromium"
          "/home/*/.config/BraveSoftware"

          # 5. DEV TOOLS (SYNCED - NUKE IT ALL)
          "/home/*/.eclipse"
          "/home/*/.p2"
          "/home/*/.vscode"
          "/home/*/.config/Code" # <--- REMOVES EVERYTHING (You use Sync)
          "/home/*/.config/Cursor" # <--- REMOVES EVERYTHING (You use Sync)

          # 6. FLATPAK & SYSTEM JUNK
          "/home/*/.var/app/*/cache"
          "/home/*/.local/share/flatpak"
          "/home/*/.local/share/nvim"
          "/home/*/.local/share/baloo"
          "/home/*/.local/state"

          # 7. PACKAGE MANAGERS
          "/home/*/.cache"
          "/home/*/.npm"
          "/home/*/.cargo"
          "/home/*/.m2"
          "/home/*/.gradle"
          "/home/*/.dotnet"
          "/home/*/.redhat"
          "/home/*/.sts4"

          # 8. SYNCED FOLDERS
          "/home/*/developing-projects"
          "/home/*/dotfiles"
          "/home/*/nixOS"
          "/home/*/progettoFDI"
          "/home/*/tools"

          # 9. APP CACHES
          "/home/*/.config/vesktop/Cache"
          "/home/*/.config/vesktop/Code Cache"
          "/home/*/.config/vesktop/GPUCache"
          "/home/*/.config/obsidian/Cache"
          "/home/*/.config/obsidian/GPUCache"
          "/home/*/.config/Slack/Cache"
          "/home/*/.config/Spotify/PersistentCache"
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
