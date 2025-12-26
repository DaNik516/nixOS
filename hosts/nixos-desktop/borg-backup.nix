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

          # 2. CLIPBOARD & DOCS (The "Bullshit" you saw)
          "/home/*/.local/share/klipper" # Clipboard History
          "/home/*/.local/share/Zeal" # Documentation Sets

          # 3. TELEGRAM JUNK (Keep login, remove emojis)
          "/home/*/.local/share/TelegramDesktop/tdata/emoji"
          "/home/*/.local/share/TelegramDesktop/tdata/temp"
          "/home/*/.local/share/TelegramDesktop/tdata/dumps"

          # 4. BROWSER JUNK (Synced)
          "/home/*/.mozilla"
          "/home/*/.config/google-chrome"
          "/home/*/.config/chromium"
          "/home/*/.config/BraveSoftware"

          # 5. DEV TOOLS & EDITORS (VS Code, Cursor, Eclipse)
          "/home/*/.eclipse"
          "/home/*/.vscode"
          "/home/*/.p2"
          "/home/*/.config/Code/CachedData"
          "/home/*/.config/Code/Cache"
          "/home/*/.config/Code/Crashpad"
          "/home/*/.config/Code/logs"
          "/home/*/.config/Code/Service Worker"
          "/home/*/.config/Code/User/workspaceStorage"
          "/home/*/.config/Code/User/History"

          "/home/*/.config/Cursor/CachedData"
          "/home/*/.config/Cursor/Cache"
          "/home/*/.config/Cursor/Crashpad"
          "/home/*/.config/Cursor/logs"
          "/home/*/.config/Cursor/GPUCache"
          "/home/*/.config/Cursor/DawnWebGPUCache"
          "/home/*/.config/Cursor/DawnGraphiteCache"
          "/home/*/.config/Cursor/Session Storage"
          "/home/*/.config/Cursor/User/workspaceStorage"
          "/home/*/.config/Cursor/User/History"

          # 6. FLATPAK & SYSTEM JUNK
          "/home/*/.var/app/*/cache" # Flatpak Caches
          "/home/*/.local/share/flatpak" # Flatpak Installs
          "/home/*/.local/share/nvim" # Neovim
          "/home/*/.local/share/baloo" # Search Index
          "/home/*/.local/state" # Logs

          # 7. PACKAGE MANAGERS
          "/home/*/.cache"
          "/home/*/.npm"
          "/home/*/.cargo"
          "/home/*/.m2"
          "/home/*/.gradle"
          "/home/*/.dotnet"
          "/home/*/.redhat"
          "/home/*/.sts4"

          # 8. CHAT/MEDIA APP CACHES
          "/home/*/.config/vesktop/Cache"
          "/home/*/.config/vesktop/Code Cache"
          "/home/*/.config/vesktop/GPUCache"
          "/home/*/.config/obsidian/Cache"
          "/home/*/.config/obsidian/GPUCache"
          "/home/*/.config/Slack/Cache"
          "/home/*/.config/Spotify/PersistentCache"

          # 9. SYNCED FOLDERS
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
