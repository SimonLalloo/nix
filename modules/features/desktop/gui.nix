{ ... }:
let
  guiAppsModule =
    { pkgs, ... }:
    {
      # TODO: figure out how to merge this & packages.nix
      environment.systemPackages = with pkgs; [
        firefox
        spotify
        obsidian
        slack
        vscode
        bitwarden-desktop
      ];
    };
in
{
  flake.nixosModules.guiApps = guiAppsModule;
  flake.darwinModules.guiApps = guiAppsModule;
}
