{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    sessionVariables = {
      JAVA_HOME = "${pkgs.jdk25}";
      JDTLS_BIN = "${pkgs.jdt-language-server}/bin/jdtls";
    };

    # -----------------------------------------------------------------------
    # ⌨️ SHELL ALIASES (Managed by Nix)
    # -----------------------------------------------------------------------
    shellAliases =
      let
        flakeDir = "~/nixOS";
      in
      {
        # Nix specific
        sw = "cd ${flakeDir} &&  nh os switch ${flakeDir}"; # Switch NixOS configuration
        upd = "cd ${flakeDir} && nh os switch --update ${flakeDir}"; # Update and switch NixOS configuration
        hms = "cd ${flakeDir} && home-manager switch --flake ${flakeDir}#$(hostname)"; # Switch Home Manager configuration
        pkgs = "nvim ${flakeDir}/home-manager/home-packages.nix"; # Edit Home Manager packages
        fmt-dry = "nix fmt -- --check"; # Check formatting without making changes (list files that need formatting)
        fmt = "cd ${flakeDir} &&  nix fmt -- **/*.nix"; # Format Nix files using nixfmt (a regular nix fmt hangs on zed theme)

        # Utilities
        npu = "read 'url?Enter URL: ' && nix-prefetch-url \"$url\"";
        r = "ranger";
        v = "nvim";
        se = "sudoedit";

        # Various
        reb-uefi = "systemctl reboot - -firmware-setup"; # Reboot into UEFI firmware settings
        swde = "cd ~/nixOS && sudo nixos-rebuild boot --flake ."; # Rebuilt boot without crash current desktop environment
      };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    # -----------------------------------------------------
    # ⚙️ SHELL INITIALIZATION
    # -----------------------------------------------------
    initContent = ''
      # 1. LOAD USER CONFIG (Stow Integration)
      if [ -f "$HOME/.zshrc_custom" ]; then
        source "$HOME/.zshrc_custom"
      fi

      # 2. TMUX AUTOSTART (Only in GUI)
      # Ensure we are in a GUI before starting tmux automatically
      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        tmux new-session
      fi

      # 3. UWSM STARTUP (Universal & Safe)
      # Guard: Only run if on physical TTY1 AND no graphical session is active.
      if [ "$(tty)" = "/dev/tty1" ] && [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
          
          # Check if uwsm is installed and ready (Safe for KDE/GNOME-only builds)
          if command -v uwsm > /dev/null && uwsm check may-start > /dev/null && uwsm select; then
              exec systemd-cat -t uwsm_start uwsm start default
          fi
      fi
    '';
  };
}
