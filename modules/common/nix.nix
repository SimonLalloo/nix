{ ... }:
let
  nixSettingsModule = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nix.gc = {
      automatic = true;
      options = "--delete-older-than 10d";
    };

    nixpkgs.config.allowUnfree = true;
  };
in
{
  flake.nixosModules.nixSettings = {
    imports = [ nixSettingsModule ];
    nix.gc.dates = "weekly";
  };

  flake.darwinModules.nixSettings = {
    imports = [ nixSettingsModule ];
    nix.gc.interval = {
      Hour = 3;
      Minute = 15;
    };
  };
}
