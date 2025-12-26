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
          # 1. STANDARD HEAVY FILES & TRASH
          "*.vdi"
          "*.qcow2"
          "*.iso"
          "/home/*/Downloads"
          "/home/*/.local/share/Trash"
          "/home/*/.local/share/recent-documents"

          # 2. BROWSER JUNK (Synced)
          "/home/*/.mozilla"
          "/home/*/.config/google-chrome"
          "/home/*/.config/chromium"
          "/home/*/.config/BraveSoftware"

          # 3. DEVELOPMENT TOOLS JUNK
          "/home/*/.eclipse" # Eclipse Install Artifacts
          "/home/*/.vscode" # VS Code Extensions
          "/home/*/.p2" # Eclipse P2 Agent

          # 4. VS CODE & CURSOR (The "Electron" Spam)
          # We keep 'User/settings.json', but nuke the heavy caches
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

          # 5. FLATPAK & SYSTEM JUNK
          "/home/*/.var/app/*/cache" # Flatpak Caches (Shader/WebKit)
          "/home/*/.local/share/flatpak" # Flatpak Installs
          "/home/*/.local/share/nvim" # Neovim (Lazy/Mason)
          "/home/*/.local/share/baloo" # Search Index
          "/home/*/.local/state" # Logs

          # 6. PACKAGE MANAGERS
          "/home/*/.cache"
          "/home/*/.npm"
          "/home/*/.cargo"
          "/home/*/.m2"
          "/home/*/.gradle"
          "/home/*/.dotnet"
          "/home/*/.redhat"
          "/home/*/.sts4"

          # 7. CHAT/MEDIA APP CACHES
          "/home/*/.config/vesktop/Cache"
          "/home/*/.config/vesktop/Code Cache"
          "/home/*/.config/vesktop/GPUCache"
          "/home/*/.config/obsidian/Cache"
          "/home/*/.config/obsidian/GPUCache"
          "/home/*/.config/Slack/Cache"
          "/home/*/.config/Spotify/PersistentCache"

          # 8. SYNCED FOLDERS (Git)
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
