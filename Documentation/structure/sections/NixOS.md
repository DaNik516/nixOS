# ⚙️ NixOS (`nixos/modules/`)
These modules control the Operating System itself. Changes here affect boot, hardware, and networking.

## `audio.nix`
Enables Pipewire, PulseAudio compatibility, and realtime scheduling for low-latency audio.

## `bluetooth.nix`
Enables the Bluetooth hardware and software stack (BlueZ) and management tools (Blueman).
 - It is set to enable bluetooth on boot and to bypass kernel rfkill list (soft blocking).
   - It is possible to make it not enable at boot by replacing the entire content with

```nix 
{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
```  

## `boot.nix`
Configures the bootloader (Systemd-boot). It manages EFI variables and detects other OSes for dual-booting.

## `core.nix`
Import all the nixos modules. When a module is added in `nixos/modules/` it is necessary to add it here to allow nixos to see it
- Desktop environment should not be added here because they are automatically enabled/disabled depending on the user choices in `variables.nix`


## `env.nix`
Sets system-wide environment variables and default application associations.
* **Environment:** Defines variables like `EDITOR` and `PATH` availability.
* **MIME Types:** Explicitly maps directories (`inode/directory`) to `ranger`, ensuring that "Open Folder" actions launch your terminal file manager instead of a graphical one.


### `gnome.nix`

This file configures the system-level components required to run the GNOME Desktop Environment.

* **Display Manager Strategy:** It enables the GNOME Desktop Manager but explicitly **does not enable GDM**. This is designed to coexist with the existing **SDDM** setup, allowing SDDM to launch GNOME sessions without conflict.
* **Guest Security:** It implements a "Lockout" mechanism for the Guest user.
* It installs an auto-start script that checks if the current user is `guest`.
* If a guest tries to log into GNOME, it triggers a **Zenity** warning ("Access Denied") and immediately kills the session, enforcing the restriction that guests may only use XFCE.

* **Debloat:** It excludes standard "bloatware" packages like Epiphany (browser), Geary (mail)
* **Conflict Resolution:** It explicitly forces the SSH password prompt tool to use KDE's `ksshaskpass` (`lib.mkForce`) to prevent build errors caused by GNOME attempting to install its own conflicting `seahorse` agent.

## `guest.nix`
Control the behavior of the guest account.
- Fixed uid (2000)
- Script that tell the user the session data will be wiped and prompt to save data on cloud or external drive
- Enable the modules only if guest = true in variables.nix
- create guest account
- allow login with no password while in sddm
- setup xfce session

## `home-manager.nix`
Hooks Home Manager into the NixOS rebuild process, allowing `nixos-rebuild` to manage home configurations

## `hyprland.nix`
The system-side enabler. It installs the `Hyprland` binary, configures the session entry for the Display Manager, and enables XWayland support.


## `kernel.nix`
Sets kernel parameters and loads specific kernel modules required for your hardware support.

## `mime.nix`
Configures default applications at the system level (`xdg-open`), ensuring links open in Firefox and files open in the correct tools.

## `net.nix`
Configures NetworkManager, sets the system `hostname`, and manages firewall rules.

## `nh.nix`
Configures `nh` (Nix Helper), a CLI tool that speeds up rebuilds and creates visual diffs of changes.

## `nix.nix`
Configures the Nix daemon itself. Enables "Flakes" (experimental feature) and sets up automatic Garbage Collection to save disk space.

## `sddm.nix`
Configuration for the Simple Desktop Display Manager (Login Screen).
* **Wayland:** Enables native Wayland support to ensure correct graphics rendering for Hyprland.
* **Theming:** Uses the official `sddm-astronaut` from official nix packages
* **Security:** Disables `autoLogin`, ensuring the login screen is always presented on boot.
* **Default session:** Automatically set based on which desktop environment is enabled

## `tailscale.nix`
Manage tailscale service


## `timezone.nix`
Sets the system time zone and locale (language, currency formats) settings.

## `user.nix`
Defines user accounts. It creates the `krit` user, assigns the `wheel` (admin/sudo) group, and sets the default login shell to Zsh. Additionally it define autologin to be off.

## `zram.nix`
Enables ZRAM swap, creating a compressed block device in RAM to improve performance when memory is low.