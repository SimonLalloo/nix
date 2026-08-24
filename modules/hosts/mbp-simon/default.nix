{ self, inputs, ... }:
{
  flake.darwinConfigurations.mbp-simon = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.darwinModules.mbpSimonConfiguration
    ];
  };
}
