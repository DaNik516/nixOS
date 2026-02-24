{ delib, ... }:
delib.module {
  name = "services.direnv";
  options.services.direnv = with delib; {
    enable = boolOption true;
  };

  home.ifEnabled = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        use_dev_env() {
          use flake /home/dani/nixOS/users/dani/dev-environments/language-specific/$1
        }
        use_combined_env() {
          use flake /home/dani/nixOS/users/dani/dev-environments/language-combined/$1
        }
      '';
    };
  };
}
