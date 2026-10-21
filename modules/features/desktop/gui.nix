{ ... }:
let
  guiAppsModule =
    { lib, pkgs, ... }:
    {
      # TODO: figure out how to merge this & packages.nix
      environment.systemPackages =
        # On darwin Firefox comes from a Homebrew cask, since the nixpkgs build is unsigned (breaks on macOS 27)
        lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.firefox
        ++ (with pkgs; [
          spotify
          obsidian
          slack
          vscode
          bitwarden-desktop
          linear
        ]);
    };
in
{
  flake.nixosModules.guiApps = guiAppsModule;
  flake.darwinModules.guiApps = {
    imports = [ guiAppsModule ];
    homebrew = {
      enable = true;
      casks = [ "firefox" ];
    };
  };
}
