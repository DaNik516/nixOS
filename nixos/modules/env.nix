{ term, ... }:
{
  environment.sessionVariables = rec {
    TERMINAL = term; # Sets the default terminal emulator for scripts and utilities
    EDITOR = "nvim"; # Sets the default text editor for git commits and command-line editing
    XDG_BIN_HOME = "$HOME/.local/bin"; # Custom variable for personal binaries in the home directory

    # 🛣️ SYSTEM PATH
    # Injects your local binary folder into the system PATH so you can
    # run custom scripts globally without typing the full file path.
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };
}
