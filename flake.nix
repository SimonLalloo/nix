{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
    nvf-config.url = "github:SimonLalloo/NVF";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nvf,
      nvf-config,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # Laptop config
        laptop = nixpkgs.lib.nixosSystem {

          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix
            inputs.home-manager.nixosModules.default

            nvf.nixosModules.default
            {
              nixpkgs.overlays = [
                (self: super: {
                  neovim = nvf-config.packages."x86_64-linux".default;
                })
              ];
            }
          ];
        };
      };
    };
}
