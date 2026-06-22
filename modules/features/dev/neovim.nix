{ self, inputs, ... }:
let
  neovimModule =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
      ];
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.myNeovim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [ ./_nvf-configuration.nix ];
        }).neovim;
    };

  flake.nixosModules.neovim = neovimModule;
  flake.darwinModules.neovim = neovimModule;
}
