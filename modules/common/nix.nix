{ inputs, ... }:
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
  # The `nixpkgs.config` above only applies to the NixOS/Darwin system pkgs.
  # perSystem's `pkgs` defaults to plain `nixpkgs.legacyPackages.<system>`, so
  # packages built there (the wrapper-modules `wrap` calls) need it separately.
  # Avante's `claude-agent-acp` pulls in the unfree `claude-code`.
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

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
