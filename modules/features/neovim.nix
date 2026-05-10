{ inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.nvf.nixosModules.default ];

      nixpkgs.overlays = [
        (final: prev: {
          neovim = inputs.nvf-config.packages."x86_64-linux".default;
        })
      ];

      environment.systemPackages = with pkgs; [
        neovim
      ];
    };
}
