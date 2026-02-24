{
  delib,
  inputs,
  pkgs,
  ...
}:
let
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  # 🌟 CORE APPS & THEME
  myBrowser = "google-chrome";
  myTerminal = "kitty";
  myShell = "zsh";
  myEditor = "vscode";
  myFileManager = "dolphin";
  myUserName = "dani";
  isCatppuccin = false;

  # 🌟 APP WORKSPACES (Keep 1 and 6 free. Keyboard key 0 = 10)
  appWorkspaces = {
    editor = "2";
    fileManager = "3";
    vm = "4";
    other = "5";
    browser-Entertainment = "7";
    terminal = "8";
    chat = "9";
  };

  # Add more if needed
  termApps = [
    "nvim"
    "neovim"
    "vim"
    "nano"
    "hx"
    "helix"
    "yazi"
    "ranger"
    "lf"
    "nnn"
  ];
  smartLaunch =
    app: if builtins.elem app termApps then "${myTerminal} --class ${app} -e ${app}" else app;

  # 🌟 DESKTOP MAP & RESOLVE FUNCTION
  desktopMap = {
    "firefox" = "firefox.desktop";
    "librewolf" = "librewolf.desktop";
    "google-chrome" = "google-chrome.desktop";
    "chromium" = "chromium-browser.desktop";
    "brave" = "brave-browser.desktop";
    "nvim" = "custom-nvim.desktop";
    "code" = "code.desktop";
    "kate" = "org.kde.kate.desktop";
    "yazi" = "yazi.desktop";
    "ranger" = "ranger.desktop";
    "dolphin" = "org.kde.dolphin.desktop";
    "thunar" = "thunar.desktop";
    "Nautilus" = "org.gnome.Nautilus.desktop";
    "nemo" = "nemo.desktop";
  };
  resolve = name: desktopMap.${name} or "${name}.desktop";
in

delib.host {
  name = "nixos-laptop";
  type = "laptop";

  homeManagerSystem = "x86_64-linux";

  myconfig =
    { ... }:
    {
      # ---------------------------------------------------------------
      # 📦 CONSTANTS BLOCK (Data Bucket)
      # ---------------------------------------------------------------
      constants = {
        hostname = "nixos-laptop";
        # ---------------------------------------------------------------
        # 👤 USER IDENTITY
        # ---------------------------------------------------------------
        user = "dani";
        gitUserName = "DaNik516";
        gitUserEmail = "camposloodanielealessandro@gmail.com";

        # ---------------------------------------------------------------
        # 🐚 SHELLS & APPS
        # ---------------------------------------------------------------
        terminal = myTerminal;
        shell = myShell;
        browser = myBrowser;
        editor = myEditor;
        fileManager = myFileManager;

        # TODO: Configure wallpaper
        /*
          wallpapers = [

              {
                targetMonitor = "eDP-1";
                wallpaperURL = "https://raw.githubusercontent.com/nicolkrit999/wallpapers/main/wallpapers/Pictures/wallpapers/various/other-user-github-repos/JoydeepMallick/Wallpapers/Anime-Girl2.png";
                wallpaperSHA256 = "05ad0c4lm47rh67hsymz0si7x62b7sanz91dsf2vaz68973fq6k6";
              }

              {
                targetMonitor = "*";
                wallpaperURL = "https://raw.githubusercontent.com/nicolkrit999/wallpapers/main/wallpapers/Pictures/wallpapers/various/other-user-github-repos/zhichaoh-catppuccin-wallpapers-main/os/nix-black-4k.png";
                wallpaperSHA256 = "144mz3nf6mwq7pmbmd3s9xq7rx2sildngpxxj5vhwz76l1w5h5hx";
              }

          ];
        */

        # ---------------------------------------------------------------
        # 🎨 THEMING
        # ---------------------------------------------------------------
        theme = {
          polarity = "dark";
          base16Theme = "dracula";
          catppuccin = false;
          catppuccinFlavor = "mocha";
          catppuccinAccent = "teal";
        };

        screenshots = "$HOME/Pictures/Screenshots";
        keyboardLayout = "it,en";
        keyboardVariant = "";

        # 🌟 RESTORED FROM VARIABLES.NIX.BAK
        weather = "Lugano";
        useFahrenheit = false;
        nixImpure = false;

        timeZone = "Etc/UTC+1";
      };

      # ---------------------------------------------------------------
      # 🌐 TOP-LEVEL MODULES
      # ---------------------------------------------------------------
      bluetooth.enable = true;

      cachix = {
        enable = true;
        push = false; # Only the builder must have this true (for now "nixos-desktop")
      };

      guest.enable = false;
      home-packages.enable = true;
      mime.enable = true;
      nh.enable = true;
      qt.enable = true;

      zram = {
        enable = true;
        zramPercent = 25;
      };

      stylix = {
        enable = true;
        targets = {
          kitty.enable = !isCatppuccin;
        };
      };

      dani.services.laptop.flatpak.enable = false;
      dani.services.laptop.local-packages.enable = true;

      # ---------------------------------------------------------------
      # 🚀 PROGRAMS
      # ---------------------------------------------------------------
      programs.bat.enable = true;
      programs.eza.enable = true;
      programs.fzf.enable = true;
      programs.kitty.enable = true;
      programs.direnv.enable = true;
      programs.dolphin.enable = true;
      programs.neovim.enable = true;

      programs.git = {
        enable = true;
        customGitIgnores = [ ];
      };

      programs.lazygit.enable = true;
      programs.shell-aliases.enable = true;
      programs.starship.enable = true;
      programs.tmux.enable = true;
      programs.walker.enable = true;

      programs.waybar = {
        enable = true;

        waybarLayout = {
          "format-it" = "🇮🇹-IT";
          "format-en" = "🇺🇸-EN";
        };

        waybarWorkspaceIcons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = ":";
          "8" = ":";
          "9" = ":";
          "10" = ":";
          "magic" = ":";
        };
      };

      programs.zoxide.enable = true;

      programs.caelestia = {
        enable = true;
        enableOnHyprland = false;
      };

      programs.noctalia = {
        enable = false;
        enableOnHyprland = false;
        enableOnNiri = false;
      };

      programs.hyprland = {
        enable = true;
        # TODO: configure monitor
        /*
          monitors = [

          ];
        */
        execOnce = [
        ];
        monitorWorkspaces = [
        ];

        windowRules = [

          # 1. Smart Launcher Rules
          "workspace ${appWorkspaces.editor}, class:^(${myEditor})$"
          "workspace ${appWorkspaces.fileManager}, class:^(${myFileManager})$"
          "workspace ${appWorkspaces.terminal}, class:^(${myTerminal})$"

          "workspace ${appWorkspaces.editor} silent, class:^(code)$"
          "workspace ${appWorkspaces.editor} silent, class:^(nvim-editor)$"
          "workspace ${appWorkspaces.editor} silent, class:^(org.kde.kate)$"
          "workspace ${appWorkspaces.editor} silent, class:^(jetbrains-pycharm-ce)$"
          "workspace ${appWorkspaces.editor} silent, class:^(jetbrains-Clion)$"
          "workspace ${appWorkspaces.editor} silent, class:^(jetbrains-idea-ce)$"
          "workspace ${appWorkspaces.fileManager} silent, class:^(org.kde.dolphin)$"
          "workspace ${appWorkspaces.fileManager} silent, class:^(thunar)$"
          "workspace ${appWorkspaces.fileManager} silent, class:^(yazi)$"
          "workspace ${appWorkspaces.fileManager} silent, class:^(ranger)$"
          "workspace ${appWorkspaces.fileManager} silent, class:^(org.gnome.Nautilus)$"
          "workspace ${appWorkspaces.fileManager} silent, class:^(nemo)$"
          "workspace ${appWorkspaces.vm} silent, class:^(winboat)$"
          "workspace ${appWorkspaces.other} silent, class:^(Actual)$"
          "workspace ${appWorkspaces.browser-Entertainment} silent, class:^(chromium-browser)$"
          "workspace ${appWorkspaces.browser-Entertainment} silent, class:^(brave-browser)$"
          "workspace ${appWorkspaces.browser-Entertainment} silent, class:^(brave-.*\..*)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(kitty)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(alacritty)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(foot)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(xfce4-terminal)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(com.system76.CosmicTerm)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(org.kde.konsole)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(gnome-terminal)$"
          "workspace ${appWorkspaces.terminal} silent, class:^(XTerm)$"
          "workspace ${appWorkspaces.chat} silent, class:^(vesktop)$"
          "workspace ${appWorkspaces.chat} silent, class:^(org.telegram.desktop)$"
          "workspace ${appWorkspaces.chat} silent, class:^(whatsapp-electron)$"

          # Scratchpad rules
          "float, class:^(scratch-term)$"
          "center, class:^(scratch-term)$"
          "size 80% 80%, class:^(scratch-term)$"
          "workspace special:magic, class:^(scratch-term)$"
          "float, class:^(scratch-fs)$"
          "center, class:^(scratch-fs)$"
          "size 80% 80%, class:^(scratch-fs)$"
          "workspace special:magic, class:^(scratch-fs)$"
          "float, class:^(scratch-browser)$"
          "center, class:^(scratch-browser)$"
          "size 80% 80%, class:^(scratch-browser)$"
          "workspace special:magic, class:^(scratch-browser)$"

          # Winboat rules
          "workspace ${appWorkspaces.vm}, class:^winboat-.*$"
          "suppressevent fullscreen maximize activate activatefocus, class:^winboat-.*$"
          "noinitialfocus, class:^winboat-.*$"
          "noanim, class:^winboat-.*$"
          "norounding, class:^winboat-.*$"
          "noshadow, class:^winboat-.*$"
          "noblur, class:^winboat-.*$"
          "opaque, class:^winboat-.*$"
        ];

        extraBinds = [
          "$Mod SHIFT, return, exec, [workspace special:magic] $term --class scratch-term"
          "$Mod SHIFT, F, exec, [workspace special:magic] $term --class scratch-fs -e yazi"
          "$Mod SHIFT, B, exec, [workspace special:magic] ${myBrowser} --new-window --class scratch-browser"
        ];
      };

      programs.niri = {
        enable = true;
        # TODO: configure monitors
        /*
          outputs = {
            "DP-1" = {
              mode = {
                width = 3840;
                height = 2160;
                refresh = 240.0;
              };
              scale = 1.5;
              position = {
                x = 1440;
                y = 560;
              };
            };
            "DP-2" = {
              mode = {
                width = 3840;
                height = 2160;
                refresh = 144.0;
              };
              scale = 1.5;
              position = {
                x = 0;
                y = 0;
              };
              transform = {
                rotation = 90;
                flipped = false;
              };
            };
            "DP-3" = {
              enable = false;
            };
            "HDMI-A-1" = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 60.0;
              };
              scale = 1.0;
            };
          };
        */
        execOnce = [
          "${myBrowser}"
          "${myEditor}"
          "${myFileManager}"
          "${myTerminal}"
        ];
      };

      programs.gnome = {
        enable = true;
        screenshots = "/home/dani/Pictures/Screenshots";
        pinnedApps = [
          (resolve myBrowser)
          (resolve myEditor)
          (resolve myFileManager)
        ];
        extraBinds = [
        ];
      };

      programs.cosmic = {
        enable = true;
      };

      programs.kde = {
        enable = true;
        pinnedApps = [
          (resolve myBrowser)
          (resolve myEditor)
          (resolve myFileManager)
        ];
        extraBinds = {
        };

      };

      # ---------------------------------------------------------------
      # ⚙️ SERVICES
      # ---------------------------------------------------------------
      services.audio.enable = true;
      services.hyprlock.enable = true;
      services.sddm.enable = true;

      services.snapshots = {
        enable = true;
        retention = {
          hourly = "24";
          daily = "7";
          weekly = "4";
          monthly = "3";
          yearly = "2";
        };
      };

      services.tailscale.enable = false;

      services.hypridle = {
        enable = true;
        dimTimeout = 900;
        lockTimeout = 1800;
        screenOffTimeout = 3600;
      };

      services.swaync = {
        enable = true;
        customSettings = {
        };
      };

    };

  # ---------------------------------------------------------------
  # ⚙️ SYSTEM-LEVEL CONFIGURATIONS
  # ---------------------------------------------------------------
  nixos =
    { ... }:
    {
      system.stateVersion = "25.11";
      imports = [
        inputs.disko.nixosModules.disko

        inputs.catppuccin.nixosModules.catppuccin
        inputs.nix-sops.nixosModules.sops
        inputs.niri.nixosModules.niri

        ./hardware-configuration.nix
        ./disko-config-btrfs-luks-impermanence.nix

      ];

      # Keep the main interface, terminal, and system language in English
      i18n.defaultLocale = "it_CH.UTF-8";

      # Override only the formats for numbers, dates, and measurements
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "it_CH.UTF-8"; # Address formatting
        LC_IDENTIFICATION = "it_CH.UTF-8"; # Identification formatting for files (only metadata)
        LC_MEASUREMENT = "it_CH.UTF-8"; # Uses Metric system (km, Celsius)
        LC_MONETARY = "it_CH.UTF-8"; # Uses CHF formatting
        LC_NAME = "it_CH.UTF-8"; # Personal name formatting (Surname Name)
        LC_NUMERIC = "it_CH.UTF-8"; # Swiss number separators
        LC_PAPER = "it_CH.UTF-8"; # Defaults printers to A4
        LC_TELEPHONE = "it_CH.UTF-8"; # Telephone number formatting (e.g. +41 79 123 45 67)
        LC_TIME = "it_CH.UTF-8"; # 24-hour clock and DD.MM.YYYY
      };

      hardware.graphics.enable = true;

      users.users.${myUserName} = {
        isNormalUser = true;
        description = "${myUserName}";
        extraGroups = [
          "wheel"
          "networkmanager"
          "input"
          "docker"
          "podman"
          "video"
          "audio"
        ];
        subUidRanges = [
          {
            startUid = 100000;
            count = 65536;
          }
        ];
        subGidRanges = [
          {
            startGid = 100000;
            count = 65536;
          }
        ];
      };

      virtualisation.docker.enable = false;
      virtualisation.docker.daemon.settings."mtu" = 1450;
      virtualisation.podman = {
        enable = false;
        dockerCompat = false;
      };

      systemd.services.cleanup_trash = {
        description = "Clean up trash older than 30 days";
        serviceConfig = {
          Type = "oneshot";
          User = myUserName;
          Environment = "HOME=/home/${myUserName}";
          ExecStart = "${pkgs.autotrash}/bin/autotrash -d 30";
        };
      };

      systemd.timers.cleanup_trash = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };

      # Solve Home-manager portal assertion
      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];

      environment.systemPackages = with pkgs; [
        autotrash
        docker
        fd
        libvdpau-va-gl
        pokemon-colorscripts
        stow
        tree
        unzip
        wget
        zip
        zlib
      ];
    };

  # ---------------------------------------------------------------
  # 🏠 USER-LEVEL CONFIGURATIONS
  # ---------------------------------------------------------------
  home =
    {
      ...
    }:
    {
      home.stateVersion = "25.11";
      imports = [

        inputs.nix-sops.homeModules.sops

      ];

      home.packages = (with pkgs; [ ]) ++ (with pkgs-unstable; [ ]);

      xdg.userDirs = {
        publicShare = null;
      };

      home.activation = {
        # Input home manager here to bypass "function home" and "attributes hm missing" evaluation errors
        createHostDirs = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p $HOME/Pictures/sfondi
        '';
      };
    };
}
