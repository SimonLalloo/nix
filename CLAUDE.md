# About

This is my NixOS flake. It is not yet complete.

I use a dendritic pattern with flake-parts and wrapper-modules. Import-tree is used to simplify imports. I also have a separate flake with a Neovim configuration, which is imported here. 

I support two hosts:
- A laptop running NixOS
- An M1 macbook pro using nix-darwin

# Structure

`flake.nix` declares all inputs and a single output expression: `inputs.import-tree ./modules`. Import-tree recursively imports every `.nix` file under `modules/`, so adding a file is enough to register it — no explicit import list anywhere.

Cross-platform feature modules export the same module body as BOTH `flake.nixosModules.<name>` and `flake.darwinModules.<name>`. Linux-only options (e.g. `programs.zsh.autosuggestions.enable`) are gated behind `lib.optionalAttrs pkgs.stdenv.isLinux`. Wrapper-modules `wrap` calls happen in `perSystem` and the resulting packages are referenced via `self.packages.${pkgs.stdenv.hostPlatform.system}.my<Tool>`.

## modules/systems.nix

Declares `systems = [ "x86_64-linux" "aarch64-darwin" ]`, which drives all `perSystem` evaluations in flake-parts.

## modules/common/

Cross-platform modules used by both NixOS and Darwin:
- `nix.nix` — exports `nixosModules.nixSettings` and `darwinModules.nixSettings` (nix daemon experimental-features, GC, allowUnfree). Each platform adds its own GC scheduling shape (`nix.gc.dates` on NixOS, `nix.gc.interval` on Darwin).
- `darwin-modules-option.nix` — flake-parts plumbing that declares `options.flake.darwinModules` as a `lazyAttrsOf deferredModule`, so multiple feature modules can each contribute a `flake.darwinModules.<name>` and have them merged. Without this, flake-parts errors with "option `flake.darwinModules' is defined multiple times".

## modules/system/

NixOS-only system-level modules. Each exports a `flake.nixosModules.<name>`:
- `base.nix` — locale, fonts, audio (PipeWire), graphics, common services (firefox, openssh, printing, udisks2, gvfs), basic system packages
- `networking.nix` — NetworkManager, Eduroam profile, resolved
- `bluetooth.nix` — Blueman, BLE
- `virtualization.nix` — Docker, VirtualBox, libvirtd, KVM

## modules/features/

Feature modules. Most export both a `perSystem.packages.<name>` (the wrapped tool, built via wrapper-modules) and a module (`flake.nixosModules.<name>`, sometimes also `flake.darwinModules.<name>`).

### shell/
All shell modules are cross-platform — they export both `nixosModules.<x>` and `darwinModules.<x>`.
- `zsh.nix` — `packages.myZsh` + `packages.myOhMyPosh` (oh-my-posh prompt, fzf, zoxide); module sets `users.users.simon.shell` and enables `programs.zsh` (option: `shells.zsh.enable`). NixOS-only `autosuggestions`/`syntaxHighlighting` are gated on `pkgs.stdenv.isLinux`.
- `nushell.nix` — `packages.myNushell` + module installs it alongside `carapace` (option: `shells.nushell.enable`).
- `tmux.nix` — `packages.myTmux` (gruvbox, vi keys; pbcopy/wl-copy selected by platform) + module installs it (option: `term.tmux.enable`).
- `direnv.nix` — `programs.direnv + nix-direnv`.
- `term.nix` — `gh`, `claude-code`, `ripgrep`, `fzf` in systemPackages.

### dev/
- `neovim.nix` — cross-platform. Installs Neovim for the current platform. Exports `nixosModules.neovim` and `darwinModules.neovim`.
- `_nvf-configuration.nix` — Neovim configuration through the NVF framework (github:notashelf/nvf) with docs at https://nvf.notashelf.dev.
- `development.nix` — cross-platform base dev tools (helix, rustup, gcc, lazygit, stylua, tree-sitter, harper, nodejs-slim, jdk, fd, gnumake; options: `development.python.enable` for Python toolchains). Exports `nixosModules.development` and `darwinModules.development`.
- `development-linux.nix` — Linux-only extras (`vscode-fhs`, `kdePackages.qtdeclarative`). Exports `nixosModules.developmentLinux`. Import only on NixOS.

### desktop/
Linux-only. Do not import on Darwin.
- `packages.nix` — `nixosModules.desktop` (spotify, discord, obsidian, syncthing, etc.; option: `desktop.photos.enable`)
- `kitty.nix` — `packages.myKitty` + `nixosModules.kitty` (installs `myKitty` via `environment.systemPackages`)
- `ghostty.nix` — `packages.myGhostty` (ghostty wrapped via `symlinkJoin` + `makeWrapper` with `--config-file=` pointing at a nix-store config; GruvboxDark theme) + `nixosModules.ghostty` (installs `myGhostty` via `environment.systemPackages`)

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
- `configuration.nix` — defines `flake.nixosModules.laptopConfiguration` (imports hardware, nixSettings, base, all feature modules including `developmentLinux`; hostname: laptop-nix)
- `hardware.nix` — defines `flake.nixosModules.laptopHardware` (filesystems, kernel modules, Intel microcode)

Rebuild: `sudo nixos-rebuild switch --flake ~/nixos#laptop`

### mbp-simon/
nix-darwin on an M1 MacBook Pro (aarch64-darwin).
- `default.nix` — defines `flake.darwinConfigurations.mbp-simon`
- `configuration.nix` — defines `flake.darwinModules.mbpSimonConfiguration`. Imports the cross-platform `darwinModules.{nixSettings, term, direnv, zsh, tmux, neovim, development}`. Does NOT import Linux-only modules (system/, desktop/, wm/, development-linux/).

Initialize: `nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#mbp-simon`
Rebuild: `sudo darwin-rebuild switch --flake .#mbp-simon`
