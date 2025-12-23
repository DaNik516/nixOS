{
  homeStateVersion,
  screenshots,
  user,
  inputs,
  pkgs,
  lib,
  ...
}:
{

  # -----------------------------------------------------------------------
  # 🔗 IMPORTS
  # -----------------------------------------------------------------------
  # Pulls in all individual program modules (Hyprland, Zsh, Neovim, etc.)
  imports = [
    ./modules/core.nix
    ./home-packages.nix
  ];

  # -----------------------------------------------------------------------
  # 👤 USER IDENTITY
  # -----------------------------------------------------------------------
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion; # Controls backwards compatibility logic
  };

  # -----------------------------------------------------------------------
  # 🏠 HOME MANAGER SELF-MANAGEMENT
  # -----------------------------------------------------------------------
  programs.home-manager.enable = true;

  # -----------------------------------------------------------------------
  # 📂 XDG USER DIRECTORIES
  # -----------------------------------------------------------------------
  # DESCRIPTION:
  # Manages ~/.config/user-dirs.dirs to tell applications (like Ranger or
  # Firefox) exactly where your standard folders are.
  # -----------------------------------------------------------------------
  xdg.userDirs = {
    enable = true; # Generates the configuration file
    createDirectories = true; # Force-creates the folders if they are missing

    # --- Standard Folders ---
    # These will be created in ~/
    # Documents, Downloads, Pictures, Videos are created by default.

    # --- Exclusions ---
    # Setting these to 'null' prevents them from appearing in your home (they are not created)
    publicShare = null; # Disable the 'Public' folder
    templates = null; # Disable the 'Templates' folder
  };

  # Create symlinks pointing nix package to specific locations.
  home.file."tools/jdtls".source = pkgs.jdt-language-server;

  # -----------------------------------------------------------------------
  # 🛠️ ACTIVATION SCRIPTS
  # -----------------------------------------------------------------------
  # DESCRIPTION:
  # Scripts that run during the 'switch' process to perform tasks that
  # declarative Nix cannot do alone (like creating deep subdirectories).
  # -----------------------------------------------------------------------

  home.activation = {
    removeExistingConfigs = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f "/home/${user}/.gtkrc-2.0"
      rm -f "/home/${user}/.config/gtk-3.0/settings.ini"
      rm -f "/home/${user}/.config/gtk-3.0/gtk.css"
      rm -f "/home/${user}/.config/gtk-4.0/settings.ini"
      rm -f "/home/${user}/.config/gtk-4.0/gtk.css"
      rm -f "/home/${user}/.config/dolphinrc"
    '';

    createEssentialDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Screenshots directory (references in other files. Make sure to change accordingly)
      mkdir -p ${screenshots}
    '';
  };
}
