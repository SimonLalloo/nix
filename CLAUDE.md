# About

This is my NixOS flake. It is not yet complete.

I use a dendritic pattern with flake-parts and wrapper-modules. Import-tree is used to simplify imports. I also have a separate flake with a Neovim configuration, which is imported here. 

I support two hosts:
- A laptop running NixOS
- An M1 macbook pro using nix-darwin

# Structure

`flake.nix` declares all inputs and a single output expression: `inputs.import-tree ./modules`. Import-tree recursively imports every `.nix` file under `modules/`, so adding a file is enough to register it — no explicit import list anywhere.

## modules/systems.nix

Declares `systems = [ "x86_64-linux" "aarch64-darwin" ]`, which drives all `perSystem` evaluations in flake-parts.

## modules/system/

NixOS-only system-level modules. Each exports a `flake.nixosModules.<name>`:
- `base.nix` — nix daemon settings, locale, fonts, audio (PipeWire), basic packages
- `networking.nix` — NetworkManager, Eduroam profile, resolved
- `bluetooth.nix` — Blueman, BLE
- `virtualization.nix` — Docker, VirtualBox, libvirtd, KVM

## modules/features/

Feature modules. Most export both a `perSystem.packages.<name>` (the wrapped tool, built via wrapper-modules) and a `flake.nixosModules.<name>` (the NixOS activation layer). The packages are cross-platform; the nixosModules are NixOS-specific unless noted.

### shell/
- `zsh.nix` — `packages.myZsh` (oh-my-posh prompt, fzf, zoxide) + `nixosModules.zsh` (option: `shells.zsh.enable`)
- `nushell.nix` — `packages.myNushell` + `nixosModules.nushell` (option: `shells.nushell.enable`)
- `tmux.nix` — `packages.myTmux` (gruvbox, vi keys; pbcopy/wl-copy selected by platform) + `nixosModules.tmux` (option: `term.tmux.enable`)
- `direnv.nix` — `nixosModules.direnv` (programs.direnv + nix-direnv; works on Darwin too)
- `term.nix` — `nixosModules.term` (gh, claude-code, ripgrep, fzf in systemPackages; works on Darwin too)

### dev/
- `neovim.nix` — `nixosModules.neovim` (imports nvf, overlays pkgs.neovim with nvf-config for the current platform)
- `development.nix` — `nixosModules.development` (helix, vscode-fhs, rustup, gcc, lazygit, etc.; options: `development.python.enable`, `development.latex.enable`). Some packages are Linux-only (vscode-fhs, kdePackages.qtdeclarative) — do not import this module on Darwin.

### desktop/
Linux-only. Do not import on Darwin.
- `packages.nix` — `nixosModules.desktop` (spotify, discord, obsidian, syncthing, etc.; option: `desktop.photos.enable`)
- `kitty.nix` — `packages.myKitty` + `nixosModules.kitty`

### wm/
Linux-only. Do not import on Darwin.
- `niri.nix` — `packages.myNiri` + `nixosModules.niri`
- `noctalia.nix` — `packages.myNoctalia` + `nixosModules.noctalia`
- `hyprland.nix` — `nixosModules.hyprland`

## modules/hosts/

Each host subdirectory has a `default.nix` that registers the top-level configuration output, and a `configuration.nix` that defines the corresponding module.

### laptop/
NixOS on a Lenovo laptop (x86_64-linux).
- `default.nix` — defines `flake.nixosConfigurations.laptop`
- `configuration.nix` — defines `flake.nixosModules.laptopConfiguration` (imports hardware, base, all feature modules; hostname: laptop-nix)
- `hardware.nix` — defines `flake.nixosModules.laptopHardware` (filesystems, kernel modules, Intel microcode)

Rebuild: `sudo nixos-rebuild switch --flake ~/nixos#laptop`

### mbp-einride/
nix-darwin on an M1 MacBook Pro (aarch64-darwin).
- `default.nix` — defines `flake.darwinConfigurations.mbp-einride`
- `configuration.nix` — defines `flake.darwinModules.mbpEinrideConfiguration`. Does NOT import nixosModules that are Linux-only (system/, desktop/, wm/, development, neovim). Shell tools, direnv, and term packages are inlined directly. Uses `self.packages.aarch64-darwin.*` for wrapped tools.

Rebuild: `darwin-rebuild switch --flake ~/nixos#mbp-einride`
