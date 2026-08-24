{ ... }:
let
  gitModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        delta
        meld

        # TODO: move this to another file
        firefox
        spotify
        obsidian
        slack
        vscode
      ];
    };
in
{
  flake.nixosModules.git = gitModule;
  flake.darwinModules.git = gitModule;
}
