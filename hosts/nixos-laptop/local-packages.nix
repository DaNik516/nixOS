{
  delib,
  pkgs,
  inputs,
  ...
}:
delib.module {
  name = "dani.services.laptop.local-packages";

  options.dani.services.laptop.local-packages.enable = delib.boolOption false;

  nixos.ifEnabled =
    { myconfig, ... }:
    let
      pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in

    {
      users.users.${myconfig.constants.user}.packages =
        (with pkgs; [
          # This allow guest user to not have this packages installed
          # Packages in each category are sorted alphabetically

          # -----------------------------------------------------------------------
          # 🖥️ DESKTOP APPLICATIONS
          # -----------------------------------------------------------------------

          localsend # Simple file sharing over local network

          telegram-desktop # Messaging
          teams-for-linux # Unofficial Microsoft Teams client
          vscode # Microsoft visual studio code IDE
          vesktop # Discord client
          whatsapp-electron # Electron wrapper for whatsapp

          # -----------------------------------------------------------------------------------
          # 🖥️ CLI UTILITIES
          # -----------------------------------------------------------------------------------
          fastfetch # Fast system information fetcher
          nix-search-cli # CLI tool to search nixpkgs from terminal
          tealdeer # Fast implementation of tldr (simplified man pages)

          # -----------------------------------------------------------------------------------
          # 🧑🏽‍💻 CODING
          # -----------------------------------------------------------------------------------
          github-desktop # GitHub's official desktop client
          zeal # Offline documentation browser

          (pkgs.python313.withPackages (
            ps: with ps; [
              faker # Generate fake data
            ]
          ))

          # -----------------------------------------------------------------------------------
          # 😂 FUN PACKAGES
          # -----------------------------------------------------------------------------------

          cbonsai # Grow bonsai trees in your terminal
          pipes # Terminal pipes animation

          # -----------------------------------------------------------------------
          # ❓ OTHER
          # -----------------------------------------------------------------------
        ])

        ++ (with pkgs-unstable; [
          # -----------------------------------------------------------------------
          # ⚠️ UNSTABLE PACKAGES (Bleeding Edge)
          # -----------------------------------------------------------------------
        ]);
    };
}
