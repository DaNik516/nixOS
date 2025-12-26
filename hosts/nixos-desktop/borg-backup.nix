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

          # 2. ENTIRE FOLDERS SYNCED ELSEWHERE
          "/home/*/.mozilla" # Firefox (Synced via Firefox Account)
          "/home/*/.config/google-chrome" # Chrome (Synced via Google)
          "/home/*/.config/chromium" # Chromium (Synced via Google)
          "/home/*/.vscode" # VS Code (Synced via GitHub)
          "/home/*/.ssh" # SSH Keys (Stored in Password Manager)
          "/home/*/developing-projects" # Git Repos
          "/home/*/dotfiles" # Git Repos
          "/home/*/nixOS" # Git Repos
          "/home/*/progettoFDI" # Git Repos
          "/home/*/tools" # Symlinks to Nix Store

          # 3. SYSTEM & APP INDEXES (Regenerable)
          "/home/*/.local/share/baloo" # KDE File Search Index
          "/home/*/.local/state" # Transient logs/state
          "/home/*/.local/share/Zeal" # Docsets

          # 4. DEV & PACKAGE MANAGER CACHES
          "/home/*/.cache"
          "/home/*/.npm"
          "/home/*/.cargo"
          "/home/*/.m2"
          "/home/*/.gradle"
          "/home/*/.dotnet"
          "/home/*/.redhat"
          "/home/*/.sts4"

          # 5. ELECTRON APP CACHES (Specifics)
          # Discord / Vesktop
          "/home/*/.config/discord/Cache"
          "/home/*/.config/discord/Code Cache"
          "/home/*/.config/vesktop/Cache"
          "/home/*/.config/vesktop/Code Cache"
          "/home/*/.config/vesktop/GPUCache"
          "/home/*/.config/vesktop/Session Storage"

          # Obsidian
          "/home/*/.config/obsidian/Cache"
          "/home/*/.config/obsidian/GPUCache"
          "/home/*/.config/obsidian/Code Cache"

          # NEOVIM PLUGINS (Re-downloadable)
          "/home/*/.local/share/nvim"

          # Others
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
