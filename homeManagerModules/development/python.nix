{ config, lib, pkgs, ... }:

with lib; {

  options = {
    development.python.enable = mkEnableOption "Enable python dev stuff";
  };

  config = mkMerge [
    # Always available
    {
      home.packages = with pkgs;
        [

          python3
        ];
    }

    # Only when enabled
    (mkIf config.development.python.enable {

      home.packages = with pkgs; [
        # Tooling
        ruff # Linter
        pyright # LSP
      ];

    })
  ];
}
