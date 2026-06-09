{ inputs, ... }:
{
  flake.nixosModules.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.nvf.nixosModules.default ];

      nixpkgs.overlays = [
        (final: prev: {
          neovim = inputs.nvf-config.packages.${prev.stdenv.hostPlatform.system}.default;
        })
      ];

      environment.systemPackages = with pkgs; [
        neovim
      ];
    };
}
