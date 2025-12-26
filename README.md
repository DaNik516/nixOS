# ❄️ Personal NixOS Config
![hyprland-showcase](./Documentation/showcase-screenshots/hyprland-showcase.png)

- [❄️ Personal NixOS Config](#️-personal-nixos-config)
  - [✨ Features](#-features)
    - [🖥️ Adaptive Host Support:](#️-adaptive-host-support)
    - [📦 Package version](#-package-version)
    - [❄️ Hybrid (declarative + non declarative for some modules)](#️-hybrid-declarative--non-declarative-for-some-modules)
    - [🎨 Theming](#-theming)
    - [🪟 Multiple Desktop Environments](#-multiple-desktop-environments)
    - [👤 Ephemeral Guest User](#-ephemeral-guest-user)
    - [🏠 Home Manager Integration](#-home-manager-integration)
    - [🧇 Tmux](#-tmux)
    - [🌟 Zsh + Starship Hybrid shell setup (local and custom) with starship.](#-zsh--starship-hybrid-shell-setup-local-and-custom-with-starship)
    - [🔢 Customizable versions](#-customizable-versions)
  - [🚀 Installation](#-installation)
    - [0. Prerequisites](#0-prerequisites)
    - [1. Install NixOS](#1-install-nixos)
    - [2. Clone the Repository](#2-clone-the-repository)
    - [3. Create Your Host Configuration (optional)](#3-create-your-host-configuration-optional)
    - [4. Import Hardware Configuration](#4-import-hardware-configuration)
    - [5. Configure the hosts folder](#5-configure-the-hosts-folder)
      - [`variables.nix`](#variablesnix)
      - [An hosts variable config example:](#an-hosts-variable-config-example)
      - [`local-packages.nix`](#local-packagesnix)
      - [`flatpak.nix`](#flatpaknix)
    - [6. (kinda optional) Configure hyprland workspaces `hyprland/main.nix`](#6-kinda-optional-configure-hyprland-workspaces-hyprlandmainnix)
    - [7. (kinda optional) KDE `kde/inputs.nix` configuration](#7-kinda-optional-kde-kdeinputsnix-configuration)
      - [How to find your Hardware IDs](#how-to-find-your-hardware-ids)
      - [Where to put the data](#where-to-put-the-data)
    - [8. (optional) Other files that may require manual attention](#8-optional-other-files-that-may-require-manual-attention)
      - [~/nixOS/home-manager/modules/waybar](#nixoshome-managermoduleswaybar)
      - [~/nixOS/home-manager/modules/firefox.nix and ~/nixOS/home-manager/modules/chromium.nix](#nixoshome-managermodulesfirefoxnix-and-nixoshome-managermoduleschromiumnix)
      - [~/nixOS/home-manager/home.nix/](#nixoshome-managerhomenix)
      - [~/nixOS/home-manager/modules/zathura.nix/](#nixoshome-managermoduleszathuranix)
      - [~/nixOS/home-manager/modules/starship.nix/](#nixoshome-managermodulesstarshipnix)
    - [9. First Time Build](#9-first-time-build)
  - [🔄 Daily Usage](#-daily-usage)
  - [❓ Troubleshooting](#-troubleshooting)
    - [Error: `path '.../hardware-configuration.nix' does not exist`](#error-path-hardware-configurationnix-does-not-exist)
    - [Error: `home-manager: command not found`](#error-home-manager-command-not-found)
    - [Error: `permission denied` opening `flake.lock`](#error-permission-denied-opening-flakelock)
    - [Error: `returned non-zero exit status 4` during rebuild](#error-returned-non-zero-exit-status-4-during-rebuild)
    - [Error: `/home/<username>/<name>' would be clobbered` during rebuild (such as with hms)](#error-homeusernamename-would-be-clobbered-during-rebuild-such-as-with-hms)
    - [Weird keyboard layout during install](#weird-keyboard-layout-during-install)
  - [❄️ Note on the declarative aspects](#️-note-on-the-declarative-aspects)
  - [📝 Project Origin and Customization](#-project-origin-and-customization)
  - [Showcase](#showcase)
    - [Hyprland](#hyprland)
    - [KDE](#kde)
    - [Gnome](#gnome)
    - [XFCE](#xfce)
  - [Other resources](#other-resources)
    - [Structure](#structure)
    - [Issues](#issues)
    - [Ideas](#ideas)


## ✨ Features

### 🖥️ Adaptive Host Support: ### 
Define unique hardware parameters (monitors, keyboard layout, idle timers, battery handling, wallpapers, etc) per machine while keeping the core environment identical. For reference look point ([5. Configure the host folder](#5-configure-the-hosts-folder))


### 📦 Package version
Allow the user to define the version of various aspects and decide if some features are enabled:
- Nixpkgs version, both stable and unstable
- Home-manager version
- Flatpak (true/false)


### ❄️ Hybrid (declarative + non declarative for some modules) ###
  - Some modules are better customized using their official methods.
  - In this case a `.nix` file applies a basic logic, while other files/directories handles the rest.
    - For a more in-depth explanation see [❄️ Note on the declarative aspects](#️-note-on-the-declarative-aspects)
 
### 🎨 Theming ## 
A base 16 colorscheme can be chosen before building (hosts-specific). The user may also chose whatever to enable catppuccin or not (along with the flavor and accent) [from the official repo](https://nix.catppuccin.com/)
  - This should allow to configure almost everything globally right from the get go
  - Wallpapers are defined to be hosts specific and they automatically apply smartly in all desktop environments except xfce (since it is the guest user default environment i decided to not mess with it)
    - Wallpapers order heavily rely on the monitor list to be in order from the main monitor to all subsequent monitors. If the order is wrong then the monitor order is wrong.
      - In kde plasma the primary monitor override this settings. This means that any monitor that is selected as `primary` get the first wallpaper of the list etc  
  
### 🪟 Multiple Desktop Environments ###
One may choose in `variables.nix` which one to enable and which one to disable. If nothing is defined it fallback to hyprland
- When switching desktop environment it is important to rebuild the boot and not the config. This allow the user to not be kicked out from the current de session if that specific de is disabled.
- Once the boot rebuild worked run the regular rebuild, both system and home-manager for example by using the zsh alias `sw && hms`   
  - If for some reason the user rebuild not in this way, then it get kicked out and only tty is available but when logging in as regular user it crash then the rebuild needs to be done through the root account:
- Until the rebuild is done personalized aspects do not work. This means the user may login into the de, but aspects like keybindings and all the personalization in hyprland do not work.
  - Especially in hyprland. If it is set to false, rebuild and then to true the personalization is not there. It is necessary to rebuild and then reboot again.
    - Most probably after re-enabling hyprland there is an error that tells that hyprland.conf may be clobbered. To allow the rebuilt it needs to be removed. This means running the following command:

```bash
# Run this if the clobbered error for hyprland.conf is encountered
rm ~/.config/hypr/hyprland.conf
```

```bash
# Run this command to avoid being kicked out from the current session
# This command allow to change to any combination of de and still have the personalized de
cd ~/nixOS && sudo nixos-rebuild boot --flake .
sw && hms
reboot
```

```bash
# Run this command if you got kicked out, are in a tty and login as normal user do not work
# First login as root
# username --> root
# password --> normally the same as the regular admin user, but this is defined during the installation of nixOS itself
# Change <username> with the default admin user where the nixOS repo is located. For example /home/krit
# This command allow to change to any combination of de and still have the personalized de
# Since the logged user is root it is better to first reboot, then login as regular user and then run sw && hms
nix-shell -p git && cd
cd /home/<username>/nixOS
git config --global --add safe.directory '*'
nixos-rebuild boot --flake .
reboot
```


  - **Hyprland + Waybar**: A modern, tile-based window compositor setup on Wayland.
  - **KDE Plasma**: A highly configurable desktop environment, with a launcher similar to windows
  - **Gnome**: A famous and simple desktop environment, with a launcher similar to macOS. Ubuntu/mint user are very used to it
  - **XFCE**: A lightweight, stable, and classic desktop experience.
    - For now xfce is enabled only if the `guest` user is enabled. 
  
### 👤 Ephemeral Guest User ### 
A specialized secure account for visitors (basic features):
  - **Login credentials**: both password and usernames are `guest`
  
  - **Restricted**: No `sudo` access and no permission to modify the NixOS configuration.
  
  - **Essential Tools**: Pre-loaded with a Browser, File Manager, Text Editor, image viewer, archive manager, calculator.
  
  - **Forced desktop environment**: This user only has access to `xfce` and its default applications. Applications that require sudo priviliges either do not open or simply fail to do anything.
  
  - **Tailscale firewall**: This user does not have access to tailscale and can not ping even local ip regardless of the  `tailscale` variable chosen in the hosts block
  
  - **Privacy Focused**: The entire user home folder (including browser cookies, sessions, and saved files) is wiped automatically on every reboot or shutdown (logging out keep the data).
    - For now this is achieved by using `tmpfs`. This tells that the user data (home path) is written on ram and not ssd/hdd.
      - This has 3 major advantages: 
        - Lifespan of the pc component (ram is rated to last more than disks)
        - Ensure privacy: Defining a script to delete the content in a disk is subject to silent fails. This means the data could not be completely removed. Ram is sure to be deleted once the pc restart 
      - The main disadvantage is possible performance issues. 
        - The current config tells that the guest user can use up to a certain ram space. This means that if a user is using more it would not be possible  

### 🏠 Home Manager Integration ### 
Fully declarative management of user dotfiles and applications.

### 🧇 Tmux ### 
Customized terminal multiplexer.

### 🌟 Zsh + Starship Hybrid shell setup (local and custom) with starship.
  
### 🔢 Customizable versions ###
  - `stateVersion`, `HomestateVersion`, `nixpkgs.url`, `home-manager` and `stylix` versions can be changed
    - Tough they can be changed individually, ideally they should match
  - `stateVersion` and `HomestateVersion` should not be changed after the first boot
    - These are hosts-specific. Each hosts can have different versions, but inside the hosts they should match
  - `nixpkgs.url`, `home-manager` and `stylix` versions can be changed freely (for example in case an update is released).
    - they should not be lower than `stateVersion` and `HomestateVersion`. This can causes unexpected downgrades and/or rebuild failures
    - note that the changes apply to all hosts

---

## 🚀 Installation

If the setup is installed completely (every feature enabled) it is suggested to have at least 128 gb of storage if the intent is to use it as main distro. For the installation expect anywhere from 20 to 40 gb. The rest is for user storage, and having at least 60 gb free in my opinion is a must in 2025



### 0. Prerequisites
- Ensure `secure boot` is disabled in the bios
- Ensure that the boot is in `UEFI` mode (not legacy/csm)

- If for some reason you want to skip this setup then see the step below to revert to systemd

To get started with this setup, follow these steps:

### 1. Install NixOS
Follow the [NixOS Installation Guide](https://nixos.org/manual/nixos/stable/#sec-installation).

**Recommended Install Settings if using nixOS gui installer:**

If a section is not included here then it does not matter since it will be changed later when the system build
* **Desktop Environment:** Select **No desktop environment** (selecting one would just install something that is later uninstalled when building)
* **Software:** Check **Allow unfree software** (tough this settings is enabled in my config for the first time installation to be successful it is needed)
* **Swap:** Select **No swap** (unless you have very low RAM)

**A note on grub:**
Since grub is defined and systemd is explicitely disabled in `/nixOS/nixos/boot.nix` a few steps to ensure that the EFI partitions are correctly should be made when the gui ask for partitioning, otherwise grub will fail to install. The steps below explains how to do it as well as the alternative of going back to systemd

During the **Partitioning** screen in the installer:

1.  **Select "Manual Partitioning"** (recommended for GRUB control) or ensure the automatic scheme creates an **EFI System Partition**.
2.  **Verify the ESP (EFI System Partition):**
    * **Size:** At least **512 MB** (100MB is the minimum, but 512MB is a better idea).
    * **File System:** `FAT32`.
    * **Mount Point:** `/boot` (NixOS default).
    * **Flags:** `boot`, `esp`.

**Why is this check necessary:**
`boot.nix` sets `grub.efiSupport = true;` and `grub.device = "nodev";`. This tells NixOS to look for an EFI partition to store the GRUB bootloader files. If the installer doesn't create this partition (or if it's too small), the rebuild will fail with as it "cannot find EFI directory" error.

**An alternative (reverse to systemd):**
To use systemd instead of grub it is enough to change `/nixOS/nixos/boot.nix` (of course after cloning the repo), see step [Clone the Repository](#2-clone-the-repository).

After cloning delete all it's content (brackets included) and put the following:

One can switch back to grub at anytime

```nix 
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
```


**Recommended Install Settings if using a minimal install:**
* **Keyboard Layout:** Run `loadkeys <layout>` (e.g., `loadkeys us`) immediately.
* **Partitioning (Manual CLI):**
  Since this config uses GRUB with specific requirements, you must manually create a GPT partition table with a 512MB EFI partition.

  1. **Identify your disk** (e.g., `/dev/nvme0n1` or `/dev/sda`):
     ```bash
     lsblk
     ```
  2. **Partition the disk** (replace `<disk>` with your actual drive, e.g., `/dev/nvme0n1`):
     ```bash
     # Create a new GPT partition table
     parted <disk> -- mklabel gpt

     # 1. Create EFI Partition (512MB, FAT32)
     parted <disk> -- mkpart ESP fat32 1MiB 512MiB
     parted <disk> -- set 1 esp on

     # 2. Create Root Partition (Rest of the disk, EXT4)
     parted <disk> -- mkpart primary ext4 512MiB 100%
     ```
  3. **Format the partitions**:
     ```bash
     # Format EFI as FAT32
     mkfs.fat -F 32 -n boot <disk>p1  # (Use p1 for nvme, 1 for sda)

     # Format Root as EXT4
     mkfs.ext4 -L nixos <disk>p2      # (Use p2 for nvme, 2 for sda)
     ```
  4. **Mount the partitions**:
     *Crucial Step:* NixOS typically mounts the EFI partition to `/boot` for GRUB.
     ```bash
     # Mount Root
     mount /dev/disk/by-label/nixos /mnt

     # Create boot directory
     mkdir -p /mnt/boot

     # Mount EFI
     mount /dev/disk/by-label/boot /mnt/boot
     ```
  5. **Generate Config**:
     ```bash
     nixos-generate-config --root /mnt
     ```

### 2. Clone the Repository
Open a terminal in your fresh install:

```bash
nix-shell -p git git clone [https://github.com/nicolkrit999/nixOS.git](https://github.com/nicolkrit999/nixOS.git)
cd nixOS/
````

### 3. Create Your Host Configuration (optional)

If you intend for your computer to **not** be named `nixos-desktop`, create a new host folder by copying the reference template:

```bash
cd ~/nixOS/hosts
cp -r template-host <your_hostname>
cd <your_hostname>
```

After this is done it is needed to modify inside `flake.nix` the `hostNames` list.
  - This list should contains the same name of all the hosts present inside the hosts directory.
    - If the hostname is not added in this list then it's entire configuration is ignored and build would not work if it contains the missing hostname in the command

```nix
hostNames = [
  "nixos-desktop"
  "nixos-laptop"
];
```  

### 4. Import Hardware Configuration

Copy the hardware scan generated during installation into your host folder:
- During the previous step the other hosts hardware-configuration.nix got copied. Now since it is overwritten if asked accept when prompted to replace the file

```bash
# This assume the current terminal path is ~/nixOS/hosts/<hostname>/
cp /etc/nixos/hardware-configuration.nix .
# Important: Git must track this file for Flakes to see it. Add it before building
# The flag -f means it track it regardless .gitignore rules (if presents)
git add -f hardware-configuration.nix
```

### 5. Configure the hosts folder
#### `variables.nix`
This file contains all the aspects that may change from host to host.
- Changes made here allow to have different environment that share the same base.
  - For example on the desktop pc one may not need the guest user, while on the laptop it may be useful 

**Variables to define:**
To have a working setup every single variable needs to be defined, otherwise the build will fail.

  * `hostname` : Must match the folder name you created in Step 3.
  
  * `system` : Architecture (e.g., `x86_64-linux`).
  
  * `user` : Your desired username.

  * `gitUserName` : Github user name.
  
  * `gitUserEmail` : Github user e-mail.
  
  * `stateVersion` & `homeStateVersion` : Keeps your config stable (e.g., `25.11`).
  
  * `hyprland` : Whatever to enable hyprland or not

   * `gnome` : Whatever to enable gnome or not

   * `kde`: Whatever to enable kde or not
  
  * `flatpak` : Whatever to enable support for flatpak
  
  * `term` : Default terminal, used for keybindings and tmux
    * Depending on the terminal it may be necessary to add an entry `set -as` to `tmux.nix`. For example:
  
  ```nix
  set -as terminal-features ",xterm-kitty:RGB"
  ```

  * `base16Theme`  which base 16 theme to use  
  * Reference https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
  
  * `polarity`  Decide whatever to have a light or a dark theme in stylix.nix
    * This should make sense with the global base16 themes. This means a dark-coloured global theme should have a dark polarity and vice-versa
    * Currently it is used in the following files:
      * `qt.nix`, `kde/main.nix` 
  
  * `catppuccin` : Whatever to enable catppuccin theming or not. If disabled all the theming is done via the base theme. Note that some modules may require attention in order to be fully customized. For more information see point 6
    
  * `catppuccinFlavor` : What catppuccin flavor to use
  
  * `catppuccinAccent` : What catppuccin Accent to use

  
  * `timezone` : Your system time zone (e.g., `Europe/Zurich`).
  
  * `weather` (waybar and kde-specific-optional): Location for the weather widget (e.g., `Lugano`).
  
  * `keyboardLayout` : Single or list of keyboard layout
  
  * `keyboardVariant` : Keyboard variant


  * `screenshots` (global-optional, a fallback apply): Setup the preferred directory where screenshots are put
    * Currently the path and shortcuts only work in hyprland and kde 
  
  * `tailscale` : Whatever to enable or disable the tailscale service.
    * "guest" user has this service disabled using a custom firewall rules in configuration.nix (host-specific)

  * `guest` : Whatever to enable or disable the guest user.
    * If the guest account is enabled then it needs to define the ram usage limit (default to 4GB). Reference ~/nixOS/nixos/modules/guest.nix section "🧹 EPHEMERAL HOME (Wipe on Reboot)"

  
  * `zramPercent` : Ram swap to enhance system performance.

  * `monitors` : List of monitor definitions (resolution, refresh rate, position).
    * The ID of a monitor is also tied to the workspace block in `/nixOS/home-manager/modules/hyprland/main.nix`
      * This block assign workspace numbers to a fixed monitor. This allow a consistent experience on multi-monitors setup. Double check the the identifiers match what you want to have. If there is only one monitor this block should be removed/commented
      * The identifier changes for each person so i did not put it hosts-specific
  
  * `wallpapers` : List of wallpapers corresponding to the monitors.

  * `idleConfig` : Power management settings (timeouts for dimming, locking, sleeping).

#### An hosts variable config example:

```nix
{
  # ---------------------------------------------------------------
  # 🖥️ HOST VARIABLES
  # ---------------------------------------------------------------

  hostname = "nixos-desktop";
  system = "x86_64-linux";

  # ⚙️ VERSIONS
  # During the first installation it is a good idea to make them the same as the other versions
  # Later where other version may be updated these 2 should not be changed, meaning they should remain what they were at the beginning
  # These 2 versions define where there system was created, and keeping them always the same it is a better idea
  stateVersion = "25.11";
  homeStateVersion = "25.11";

  # 👤 USER IDENTITY
  user = "krit";
  gitUserName = "nicolkrit999";
  gitUserEmail = "githubgitlabmain.hu5b7@passfwd.com";

  # 🖥️ DESKTOP ENVIRONMENT
  hyprland = true;
  gnome = true;
  kde = true;

  # 📦 PACKAGES & TERMINAL
  flatpak = true;
  term = "kitty";

  # 🎨 THEMING
  base16Theme = "nord";
  polarity = "dark";
  catppuccin = false;
  catppuccinFlavor = "mocha";
  catppuccinAccent = "sky";

  # ⚙️ SYSTEM SETTINGS
  timeZone = "Europe/Zurich";
  weather = "Lugano";
  keyboardLayout = "us,ch,de,fr,it";
  keyboardVariant = "intl,,,,";

  screenshots = "$HOME/Pictures/screenshots";

  # 🛡️ SECURITY & NETWORKING
  tailscale = true;
  guest = true;
  zramPercent = 25;

  # 🖼️ MONITORS & WALLPAPERS
  monitors = [
    "DP-1,3840x2160@240,1440x560,1.5"
    "DP-2,3840x2160@144,0x0,1.5,transform,1"
    "HDMI-A-1,disable"
  ];

  wallpapers = [
    {
      wallpaperURL = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/refs/heads/main/os/nix-black-4k.png";
      wallpaperSHA256 = "144mz3nf6mwq7pmbmd3s9xq7rx2sildngpxxj5vhwz76l1w5h5hx";
    }
    {
      wallpaperURL = "https://raw.githubusercontent.com/HyDE-Project/hyde-themes/Catppuccin-Mocha/Configs/.config/hyde/themes/Catppuccin%20Mocha/wallpapers/switch_swirl.jpg";
      wallpaperSHA256 = "1zhg5cx0x6b691jbbn15ggyqrxnvzvfsv3r89f6hg7rpwvnvhbcl";
    }
  ];

  # 🔋 POWER MANAGEMENT
  idleConfig = {
    enable = true;
    dimTimeout = 600;
    lockTimeout = 1800;
    screenOffTimeout = 3600;
    suspendTimeout = 7200;
  };
}

```

#### `local-packages.nix`
- It contains packages that are intended to only be installed in that specific hosts
  - Remove/add/change as needed

#### `flatpak.nix`
- It contains flatpak packages that are intended to only be installed in that specific hosts
  - Remove/add/change as needed  

### 6. (kinda optional) Configure hyprland workspaces `hyprland/main.nix`
- For me i configured some workspaces to be binded to a certain monitor. To achieve this it is necessary to tell the workspace number and the monitor identifier.
  - Since the identifier may change, or other user may not want this logic or may want to edit it this part require modification
- If these changes are not done then it default to show a workspace in the monitor the mouse is currently hovered

```nix
workspace = [
        "w[tv1], gapsout:0, gapsin:0" # No gaps if only 1 window is visible
        "f[1], gapsout:0, gapsin:0" # No gaps if window is fullscreen

        "1, monitor:DP-1"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"

        "6, monitor:DP-2"
        "7, monitor:DP-2"
        "8, monitor:DP-2"
        "9, monitor:DP-2"
        "10, monitor:DP-2"
      ]; 
```

### 7. (kinda optional) KDE `kde/inputs.nix` configuration 

This configuration uses `plasma-manager` to strictly manage input devices (Mouse & Touchpad). Unlike generic Linux configs, Plasma Manager requires specific **Hardware IDs** to apply settings like "No Acceleration" or "Tap to Click".

If this step is not done kde recognize that the id do not match and it will apply the default settings.
- Since it is defined it would be better to either comment out/remove completely this module or put the right data

#### How to find your Hardware IDs
Run the following command in your terminal to list input devices:

```bash
# For Mouse
cat /proc/bus/input/devices | grep -A 5 "Mouse"

# For Touchpad
cat /proc/bus/input/devices | grep -A 5 "Touchpad"
````

Look for the output line starting with `I: Bus=...`. You need the **Vendor** and **Product** codes (4 characters each).

**Example Output:**

```text
N: Name="Logitech G403 HERO Gaming Mouse"
...
I: Bus=0003 Vendor=046d Product=c08f Version=0111
```

#### Where to put the data

1.  Open `home-manager/modules/kde/inputs.nix`.
2.  Update the `mice` or `touchpads` list with your specific values.


```nix
    mice = [
      {
        enable = true;
        name = "Logitech G403"; 
        vendorId = "046d";  # <--- Update this
        productId = "c08f"; # <--- Update this
        
        acceleration = -1.0;
        accelerationProfile = "none";
      }
    ];
```

**Note for Desktop Users:** Keep the `touchpads` list empty (`[]`), or comment it  to avoid errors.

**Note for Laptop Users:** Uncomment the touchpad section and add your specific IDs.


### 8. (optional) Other files that may require manual attention
- These files can be modified also after building.
  - These are files that one most likely will want to configure right from the beginning because they cause a "wrong" experience

#### ~/nixOS/home-manager/modules/waybar
Files that needs attentions are:
-  ~/nixOS/home-manager/modules/waybar/default.nix
   - `format-icons`: This block define certain icon based on fixed workspace.  
     - One would want to customize them since a workspace number may not reflect the user intended app

   - `hyprland/language`: This block defines the countries flags that are shown when changing keyboard layout.
     - One would want to customize then to match the layout to the flag
  
- ~/nixOS/home-manager/modules/waybar/style.css
  - `🧩 RIGHT-SIDE MODULES`: It contains hardcoded colors, such as @peach and @green. Change them by using one of the provided options in `./default.nix` map colors or define a new one using `@define-color`

#### ~/nixOS/home-manager/modules/firefox.nix and ~/nixOS/home-manager/modules/chromium.nix
- They contains personalized aspects like homepage, toolbars visible items, extensions. One may want to change them

#### ~/nixOS/home-manager/home.nix/
It make sure certain directories are created/excluded. One may not need them
- Created folders are under `home.activation`
  - the screenshot path is forced in all desktop environment. 
- It create some others folder that one may not use 
- Excluded folders are under `xdg.userDirs` (if a directory is set to `null` then it is disabled)
- It include a symlink for `~/tools/jdtls`. One may want to delete it

#### ~/nixOS/home-manager/modules/zathura.nix/
- The font size and family is hardcoded. One may want to change it

#### ~/nixOS/home-manager/modules/starship.nix/
- I disabled `enableZshIntegration = false;` because it's eval is defined in my stowed .zshrc_custom. if that is not the case then one may need to enable it


### 9. First Time Build

This setup contains lot of packages, dependencies and similar so first time build can take some times depending on internet speed

Run the following commands to install the system and user configurations.

**Replace `<hostname>` with the hostname defined in `flake.nix`.**

- Remember that the hostname in `flake.nix` hosts sections and the actual directory name inside the parent `hosts` directory should match
- Additionally in the second step the version in which the command is run should match the home-manager version defined in `flake.nix`

```bash
cd ~/nixOS/

# 1. Build the System (Root Level)
# For example: sudo nixos-rebuild switch --flake .#nixos-desktop
sudo nixos-rebuild switch --flake .#<hostname>

# 2. Build the Home (User Level)
# Note: Since 'home-manager' is not installed yet, 'nix run' alllow to bootstrap it.
home-manager switch
```

*(Note: Use `.#<hostname>` for Home Manager as well, as the flake outputs are keyed by hostname.)*

-----

## 🔄 Daily Usage

Once installed, you can switch the git remote to SSH (optional) (this assume you already added the hosts-specific ssh key to github) and use the convenient aliases for maintenance (if you are `krit`). This avoid asking the github password each time a rebuild is needed.
- If you are not krit then the only way to allow this is to fork the repository and change the url to your github username
  - The username is visibile in the link of the repo once it is forked 

```bash
# For example: git remote set-url origin git@github.com:nicolkrit999/nixOS.git
git remote set-url origin git@github.com:<github-username>/nixOS.git
```

**Maintenance Aliases:**

| Command | Action                  | Description                                                                   |
| :------ | :---------------------- | :---------------------------------------------------------------------------- |
| # `sw`  | `nh os switch`          | **System Rebuild**. Applies changes to `configuration.nix` or system modules. |
| # `hms` | `nh home switch`        | **Home Rebuild**. Applies changes to Home Manager (dotfiles, themes).         |
| # `upd` | `nh os switch --update` | **System Update**. Updates `flake.lock` inputs and rebuilds the system.       |

-----

## ❓ Troubleshooting

### Error: `path '.../hardware-configuration.nix' does not exist`

**Cause:** Nix Flakes only see files that are tracked by Git (you skipped `git add -f` in step 4).
**Fix:** Force add the file to git:

```bash
git add -f hosts/<hostname>/hardware-configuration.nix
```

### Error: `home-manager: command not found`

**Cause:** You removed the system-wide package, but the user-level package hasn't installed yet.
**Fix:** Run the bootstrap command again (step 6 part 2):

```bash
home-manager switch
```

### Error: `permission denied` opening `flake.lock`

**Cause:** You cloned the repo as root but are trying to build as a user.
**Fix:** Fix ownership:

```bash
# This smart command automatically fetch the useranem so no changes are needed
sudo chown -R $USER:users ~/nixOS
```

### Error: `returned non-zero exit status 4` during rebuild

**Cause:** Common during massive updates. System built fine but failed to restart a service (often DBus).
- Some time the rebuild seems stuck.
  - Tough it may also be a true stuck chanches are that the system correctly builded but can not show this in the cli 

**Fix:** Safe to ignore. Reboot your computer.

### Error: `/home/<username>/<name>' would be clobbered` during rebuild (such as with hms)

**Cause:** Sometime even if it is forced nix refuse to build because a certain file/directory would be clobbered. This happen especially in `gtk* files`

**Fix:** Remove the file/directory interested and rebuild

### Weird keyboard layout during install
This is a problem that i encountered. It may have been user error but i write it here just to be safe.

Even tough i selected us international during the gui installer once rebooted into cli (since i selected no desktop) i was greeted with all mixed keys. Meaning what i saw on the physical keyboard were not the keys that were pressed.
- For me the layout that nixOS had at that moment in time was `dvorak`
- This is solvable by manually converting the keyboards or just ask an ai what keys to press on a dvorak layout to actually input what the user wants. After the user login is successful input the following command `loadkeys <layout>` (until this command run successfully the keyboard layout is still `dvorak`). After this the problem should be solved and since the layout are chosen declarative this should not be a problem anymore



## ❄️ Note on the declarative aspects

Some modules are better customized using their official methods.

These modules uses a dedicated `*.nix` file where it defines that the main configuration is taken from another place and unified with the respective `*.nix` file

These blocks are configured in such a way that allow 2 scenario:

1: The user has a customized setup (either with stowing from another github repo) or directly in the original intended location.
  - In this case there is an hybrid environment. Meaning everything defined in both `*.nix` files and the original file/directory apply

2: The user does not have a customized setup the original location is either empty or default (after installing the program)
  - In this case the behaviour in `*.nix` apply but since the rest is default it is like not applying it at all

Currently this behaviour happens for 2 programs: 
- **Neovim**: 
  - Nix reference: `neovim.nix`
  - Original reference: `~/.config/nvim/*`
- **zsh**: 
  - Nix reference: `zsh.nix`
  - Original reference: `~/.zshrc_custom`



## 📝 Project Origin and Customization

This NixOS configuration project began as local copy and adaptation of the excellent work by **Andrey0189** from their repository: [https://github.com/Andrey0189/nixos-config-reborn](https://github.com/Andrey0189/nixos-config-reborn).

I would like to extend my thanks to **Andrey0189** for providing a robust starting point.

While the original repository laid the foundation, this setup has been **heavily customized** and expanded over time to suit my personal needs and workflows. Key changes include:

* **Heavily improved hosts variables**: Modified the hosts directory such that it contains many more aspects that can differs from host to host
* **Multiple Desktop Environments**: Added configuration and support for multiple desktop environments
* **Ephemeral Guest User**: Implemented a secure, non-persistent guest account with automatic home directory wiping on reboot.
* **Theming Overhaul**: Integrated a base 16 colorscheme selection alongside Catppuccin official theming via `stylix`.
* **Hybrid Declarative Aspects**: Detailed and implemented a hybrid approach for tools like Neovim and Zsh, allowing for declarative configuration while respecting and integrating official, non-declarative customization methods.
* **Flake Configuration**: Enhanced the `flake.nix` file to suit the logic that there are many more variables that differs from hosts to hosts

This README documents the final, highly customized iteration of that initial framework.

The LICENCE.txt file is copied from the original repo and should respect the GPLv3 terms
- If there are any problems reach me by e-mail githubgitlabmain.hu5b7@passfwd.com


## Showcase
These photos contains the following options:
```nix
guest = true;
base16Theme = "nord";
polarity = "dark";
catppuccin = false;
catppuccinFlavor = "mocha"; 
catppuccinAccent = "sky"; 
```


### Hyprland
![hyprland-showcase](./Documentation/showcase-screenshots/hyprland-showcase.png)

### KDE
![kde-showcase](./Documentation/showcase-screenshots/kde-showcase.png)

### Gnome
![gnome-showcase](./Documentation/showcase-screenshots/gnome-showcase.png)

### XFCE
![xfce-showcase](./Documentation/showcase-screenshots/xfce-showcase.png)




## Other resources
### [Structure](./Documentation/structure/Structure.md)
These files contains the entire structure of the project, with an explanation of every single file

### [Issues](./Documentation/issues/issues.md)
These file contains issues that i noticed that should be resolved
- Issues include both warnings than critical one

### [Ideas](./Documentation/ideas/ideas.md)
These file contains ideas that i think may benefit the project






