{ inputs, ... }:
{
  flake.nixosModules.neovim = {
    imports = [ inputs.nvf.nixosModules.default ];

    nixpkgs.overlays = [
      (final: prev: {
        neovim = inputs.nvf-config.packages."x86_64-linux".default;
      })
    ];
  };
}
