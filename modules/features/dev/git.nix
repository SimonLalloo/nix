{ ... }:
let
  gitModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        delta
        meld
      ];
    };
in
{
  flake.nixosModules.git = gitModule;
  flake.darwinModules.git = gitModule;
}
