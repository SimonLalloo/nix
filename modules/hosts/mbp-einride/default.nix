{ self, inputs, ... }:
{
  flake.darwinConfigurations.mbp-einride = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit inputs self; };
    modules = [
      self.darwinModules.mbpEinrideConfiguration
    ];
  };
}
