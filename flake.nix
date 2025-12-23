{
  description = "My personal nixOS configuration with multi-host support ";

  # -----------------------------------------------------------------------
  # 📥 INPUTS
  # -----------------------------------------------------------------------
  # Defines the external sources (repositories) that your configuration depends on.
  # -----------------------------------------------------------------------
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; # NixOS channel (25.11)

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Unstable Nixpkgs for latest packages

    nix-flatpak.url = "github:gmodena/nix-flatpak"; # Flatpak support for NixOS

    # Home Manager: Manages your home directory and dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures HM uses the same nixpkgs as the system
    };

    # Stylix: Unified theming for the entire system
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Forces it to use the cached system version. This avoid redownloading after a garbage collection
    };

    # Firefox Addons: Declarative browser plugin management
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs"; # Forces it to use the cached system version. This avoid redownloading after a garbage collection
    };

    # CATPPUCCIN THEME (official module): Aesthetic pastel theme for apps and the system  https://github.com/catppuccin/nix
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Forces it to use the cached system version. This avoid redownloading after a garbage collection
    };

    # Plasma Manager: GUI tool to manage KDE Plasma settings "https://github.com/nix-community/plasma-manager"
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Forces it to use the cached system version. This avoid redownloading after a garbage collection
      inputs.home-manager.follows = "home-manager";
    };

    # COMING SOON...
    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  # ───────────────────────────────────────────────────────────────────────────────
  # MULTI-HOST CONFIGURATION
  # ───────────────────────────────────────────────────────────────────────────────
  # You can define as many hostnames as needed in the `hosts` list below.
  # Each host requires a corresponding folder in `hosts/<hostname>/` containing:
  #   - configuration.nix        (can be shared or customized per host)
  #   - local-packages.nix       (can be shared or customized per host)
  #   - hardware-configuration.nix  (unique per machine, auto-generated)
  #
  # To add a new host:
  #   1. Add entry: { hostname = "new-host"; stateVersion = "25.11"; }
  #   2. Create folder: cp -r hosts/nixos-desktop hosts/new-host
  #   3. Replace hardware-configuration.nix with the one from /etc/nixos/
  #
  # Rebuild with: sudo nixos-rebuild switch --flake .#<hostname>
  # ───────────────────────────────────────────────────────────────────────────────
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let

      # List of hosts using this configuration
      hosts = [
        rec {
          hostname = "nixos-desktop"; # Main desktop  Do not forget the semicolon

          # ------------------------------------------------------------------
          # 🖥️ SYSTEM ARCHITECTURES REFERENCE
          # ------------------------------------------------------------------
          # | Value             | Hardware Example                            |
          # |-------------------|---------------------------------------------|
          # | "x86_64-linux"    | Most Intel/AMD Desktops & Laptops           |
          # | "aarch64-linux"   | Raspberry Pi 4/5, AWS Graviton, mac (vm)    |
          # | "i686-linux"      | Very old 32-bit Intel CPUs                  |
          # ------------------------------------------------------------------
          system = "x86_64-linux"; # System architecture

          user = "krit"; # Your system username

          stateVersion = "25.11"; # Do not forget the semicolon. This should not be changed afterward and should match the NixOS homeStateVersion as well as the releases of nixpkgs and home-manager
          homeStateVersion = "25.11"; # Do not forget the semicolon. This should not be changed afterward and should match the NixOS stateVersion as well as the releases of nixpkgs and home-manager

          # 🖥️ DESKTOP ENVIRONMENT
          # XFCE is enabled only if guest is true
          hyprland = true;
          gnome = true;
          kde = true;

          flatpak = true; # Whether to enable Flatpak support on this host

          term = "kitty"; # Preferred terminal emulator

          screenshots = "/home/${user}/Pictures/screenshots"; # Default folder for screenshots (ideally use an absolute path)

          timeZone = "Europe/Zurich"; # Do not forget the semicolon
          weather = "Lugano"; # Semicolon ✅ (End of weather assignment)

          keyboardLayout = "us,ch,de,fr,it"; # Global keyboard for general desktop environments
          keyboardVariant = "intl,,,,"; # Variants for the above layouts (one comma per layout)

          gitUserName = "nicolkrit999"; # Your public display name on commits
          gitUserEmail = "githubgitlabmain.hu5b7@passfwd.com"; # Email linked to GitHub/GitLab

          tailscale = true; # Whether to enable Tailscale VPN on this host

          guest = true; # Whether to enable the guest user on this host

          # Global stylix theme
          base16Theme = "nord"; # Global theme for stylix. Refer to "https://github.com/tinted-theming/schemes/tree/spec-0.11/base16". Do not include the .yaml extension
          polarity = "dark"; # Sets a global preference for stylix (dark or light)

          # Catppuccin theming. If not using it is enough to set `catppuccin = false;` and keep the rest as default
          # Refer to "https://catppuccin.com/palette/"
          # Currently there is no check for syntax correctness so be careful when editing these values
          catppuccin = false;
          catppuccinFlavor = "mocha"; # Catppuccin flavor to use (lowercase) (latte, frappe (no accent), macchiato, mocha)
          catppuccinAccent = "sky"; # Catppuccin accent to use (lowercase)

          # 🧠 ZRAM CONFIGURATION (Host Specific)
          # How much RAM to use as Swap? (Integer 0-150)
          # 4GB RAM -> 100 | 8GB -> 75 | 16GB -> 50 | 32GB+ -> 25
          zramPercent = 25; # Semicolon ✅ (End of zramPercent assignment)

          # Monitors setup for main.nix
          monitors = [
            # -----------------------------------------------------------------------------------------------------
            # HYPRLAND MONITOR FORMAT:
            # name, resolution@rate(optional), position(optional), scale, transform(optional), mirrored (optional)
            #
            # 1. name:           The connector name (e.g., DP-1, HDMI-A-1, etc.)
            # 2. resolution@rate: The physical resolution (width x height) and refresh rate (Hz).
            #    * IMPORTANT: For 'transform' (rotation), you must swap WxH here (e.g., 2160x3840 for 4K portrait).
            # 3. position:       The coordinate (XxY) of the top-left corner on the virtual desktop.
            # 4. scale:          The DPI scaling factor (e.g., 1 for 100%, 1.5 for 150%).
            # 5. transform:      Rotation/Flip index (0=0deg, 1=90deg, 2=180deg, 3=270deg). --> e.g "transform,1"
            # 6. mirrored:       mirror, name --> e.g "DP-2,mirror,DP-1"
            #
            # EXAMPLE SCENARIO:
            # - DP-1 (Left, Portrait): Starts at 0x0, rotated 90 degrees (transform 1).
            # - DP-2 (Right, Landscape): Starts at 2160x840 (840px down to center vertically below the 3840px high portrait monitor).
            # - "DP-1,3840x2160@144,0x0,1,transform,1"
            # -----------------------------------------------------------------------------------------------------

            # 1. DP-1 (Primary, Right, Landscape) -- FIRST IN LIST (Gets Wallpaper #1)
            # Specs: 4K 240Hz, Scaled 1.5
            # Logical Size: 2560 x 1440
            # Position X: 1440 (Placed to the right of the portrait monitor)
            # Position Y: 560  (Centered vertically relative to DP-2)
            "DP-1,3840x2160@240,1440x560,1.5"

            # 2. DP-2 (Secondary, Left, Portrait) -- SECOND IN LIST (Gets Wallpaper #2)
            # Specs: 4K 144Hz, Rotated 90 deg, Scaled 1.5
            # Logical Size: 1440 x 2560
            # Position: 0x0 (Starts at the absolute left)
            "DP-2,3840x2160@144,0x0,1.5,transform,1"

            # Disable unused
            "HDMI-A-1,disable"
          ]; # Semicolon ✅ (End of monitors assignment)

          # 🖼️ Define a list of wallpapers
          # First wallpaper goes to first monitor, second to second, etc.
          # In my specific case i switched the order because my main monitor has identifier DP-1
          # To convert a normal github visit https://git-rawify.vercel.app/ or do it manually:
          # 1. Replace github.com with raw.githubusercontent.com
          # 2. Remove /blob from the URL path
          # Example:
          # Normal URL: https://github.com/User/Repo/blob/main/image.png
          # Raw URL: https://raw.githubusercontent.com/User/Repo/main/image.png
          # Then use nix-prefetch-url "<raw_link>" to get the wallpaperSHA256

          # If during a prefetch there is an error saying that it contains illegal characters such as "%" then appen the name of the file using --name "<name>"
          # The name should be the name of the file with all special characters and number removed,
          # for example nix-prefetch-url "https://raw.githubusercontent.com/HyDE-Project/hyde-themes/Catppuccin-Mocha/Configs/.config/hyde/themes/Catppuccin%20Mocha/wallpapers/2%20rain_world.png" --name "rain_world.png"
          # The following characters are valid and should remain in the "<name>" part : letters, dashes (-), underscores (_), and dots (.).

          # Wallpapers setup for hyprpaper.nix
          wallpapers = [
            {
              # Wallpaper for Monitor 2 (DP-1) (Main Gaming)
              wallpaperURL = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/os/nix-black-4k.png";
              wallpaperSHA256 = "144mz3nf6mwq7pmbmd3s9xq7rx2sildngpxxj5vhwz76l1w5h5hx"; # To get the hash use `nix-prefetch-url "YOUR_URL_HERE"`
            } # ❌ NO SEMICOLON HERE (Item in a list)

            {
              # Wallpaper for Monitor 1 (DP-2) (Secondary Vertical)
              wallpaperURL = "https://raw.githubusercontent.com/HyDE-Project/hyde-themes/Catppuccin-Mocha/Configs/.config/hyde/themes/Catppuccin%20Mocha/wallpapers/switch_swirl.jpg";
              wallpaperSHA256 = "1zhg5cx0x6b691jbbn15ggyqrxnvzvfsv3r89f6hg7rpwvnvhbcl"; # To get the hash use `nix-prefetch-url "YOUR_URL_HERE"`
            } # ❌ NO SEMICOLON HERE (Item in a list)

          ]; # Semicolon ✅ (End of wallpapers assignment)

          # Hidling settings for hypridle.nix (expressed in seconds)
          idleConfig = {
            # Should the idle daemon run at all?
            enable = true;

            # Stage 1: Dim Screen (10 mins)
            dimTimeout = 600;

            # Stage 2: Lock Screen (30 mins)
            lockTimeout = 1800;

            # Stage 3: Turn Off Screen (60 mins)
            screenOffTimeout = 3600;

            # Stage 4: Deep Sleep / Suspend (2 hours)
            suspendTimeout = 7200;
          }; # Semicolon ✅ (End of idleConfig assignment)

        } # ❌ NO SEMICOLON HERE (Because this object is inside the 'hosts = [ ... ]' list)
        # Add more hosts here as needed (copy the structure above from nixos-desktop)
        # hosts = []
      ];

      # 🛠️ SYSTEM BUILDER
      makeSystem =
        {
          hostname,
          system,
          user,
          stateVersion,
          hyprland ? true,
          gnome ? false,
          kde ? false,
          flatpak ? false,
          term ? "alacritty",
          screenshots ? "/home/${user}/Pictures/screenshots",
          wallpapers,
          timeZone,
          keyboardLayout ? "us",
          keyboardVariant ? "",
          zramPercent ? 25,
          tailscale ? false,
          guest ? false,
          base16Theme ? "catppuccin-mocha",
          polarity ? "dark",
          catppuccin ? false,
          catppuccinFlavor ? "mocha",
          catppuccinAccent ? "mauve",
          ...
        }:
        let
          pkgs-unstable = import nixpkgs-unstable {
            localSystem = system;
            config.allowUnfree = true;
          };
        in
        nixpkgs.lib.nixosSystem {

          pkgs = import nixpkgs {
            localSystem = system;
            config.allowUnfree = true;
          };

          specialArgs = {
            inherit
              inputs
              stateVersion
              hyprland
              flatpak
              term
              hostname
              user
              screenshots
              wallpapers
              keyboardLayout
              keyboardVariant
              zramPercent
              tailscale
              guest
              base16Theme
              polarity
              catppuccin
              catppuccinFlavor
              catppuccinAccent
              pkgs-unstable
              ; # do not forget the semicolon
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.catppuccin.nixosModules.catppuccin
            inputs.nix-flatpak.nixosModules.nix-flatpak

            {
              nixpkgs.hostPlatform = system;
              time.timeZone = timeZone;
            }
          ]

          ++ (nixpkgs.lib.optional hyprland ./nixos/modules/hyprland.nix)
          ++ (nixpkgs.lib.optional gnome ./nixos/modules/gnome.nix)
          ++ (nixpkgs.lib.optional kde ./nixos/modules/kde.nix);
        };

      # 🏠 3. HOME BUILDER (Home Manager Recipe)
      # Parts after the "?" are fallback. If it is an empty bracket the fallback is handled in the reference file
      makeHome =
        {
          hostname,
          wallpapers,
          monitors ? [ ],
          idleConfig ? null,
          weather ? "Lugano",
          screenshots ? "/home/${user}/Pictures/screenshots",
          system,
          user,
          homeStateVersion,
          hyprland ? true,
          gnome ? false,
          kde ? false,
          term ? "alacritty",
          keyboardLayout ? "us",
          keyboardVariant ? "",
          gitUserName ? "",
          gitUserEmail ? "",
          base16Theme ? "catppuccin-mocha",
          polarity ? "dark",
          catppuccin ? false,
          catppuccinFlavor ? "mocha",
          catppuccinAccent ? "mauve",
          ...
        }:

        let
          pkgs-unstable = import nixpkgs-unstable {
            localSystem = system;
            config.allowUnfree = true;
          };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            localSystem = system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit
              inputs
              homeStateVersion
              term
              user
              monitors
              wallpapers
              idleConfig
              weather
              screenshots
              keyboardLayout
              keyboardVariant
              gitUserName
              gitUserEmail
              base16Theme
              polarity
              catppuccin
              catppuccinFlavor
              catppuccinAccent
              pkgs-unstable
              ; # do not forget the semicolon
          };
          modules = [
            ./home-manager/home.nix
            inputs.catppuccin.homeModules.catppuccin
            inputs.plasma-manager.homeModules.plasma-manager
            ./home-manager/modules/wofi

          ]

          ++ (nixpkgs.lib.optionals hyprland [
            ./home-manager/modules/hyprland
            ./home-manager/modules/waybar
            ./home-manager/modules/swaync
          ])

          ++ (nixpkgs.lib.optional gnome ./home-manager/modules/gnome)
          ++ (nixpkgs.lib.optional kde ./home-manager/modules/kde);
        };

    in
    {
      # 🚀 4. AUTOMATIC GENERATION LOOP
      nixosConfigurations = nixpkgs.lib.foldl' (
        configs: host:
        configs
        // {
          "${host.hostname}" = makeSystem host;
        }
      ) { } hosts;

      # Generates: homeConfigurations."nixos-desktop"
      homeConfigurations = nixpkgs.lib.foldl' (
        configs: host:
        configs
        // {
          "${host.hostname}" = makeHome host;
        }
      ) { } hosts;

      # Takes the architecture from the hosts where the flake is being built
      formatter = nixpkgs.lib.genAttrs (nixpkgs.lib.unique (builtins.map (host: host.system) hosts)) (
        system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style
      );
    };
}
