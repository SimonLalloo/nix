{ inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        inputs.nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
