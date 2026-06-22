{ ... }:
let
  direnvModule = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
in
{
  flake.nixosModules.direnv = direnvModule;
  flake.darwinModules.direnv = direnvModule;
}
