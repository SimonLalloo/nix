{ inputs, ... }:
let
  neovimModule =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
in
{
  flake.nixosModules.neovim = neovimModule;
  flake.darwinModules.neovim = neovimModule;
}
