{ ... }:
let
  developmentModule =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = {
        development.python.enable = lib.mkEnableOption "Enable Python development environment";
      };

      config.environment.systemPackages =
        with pkgs;
        [
          helix
          rustup
          gcc
          lazygit
          stylua
          tree-sitter
          harper
          nodejs-slim
          jdk
          fd
          gnumake
          meld
        ]
        ++ lib.optionals config.development.python.enable [
          ruff
          pyright
          (python3.withPackages (
            ps: with ps; [
              numpy
              matplotlib
              pandas
              pip
            ]
          ))
        ];
    };
in
{
  flake.nixosModules.development = developmentModule;
  flake.darwinModules.development = developmentModule;
}
