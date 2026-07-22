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
        development.latex.enable = lib.mkEnableOption "Enable LaTeX development environment";
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
              pip
            ]
          ))
        ]
        ++ lib.optionals config.development.latex.enable [
          texlive.combined.scheme-full
          zathura
          texlab
          ltex-ls
        ];
    };
in
{
  flake.nixosModules.development = developmentModule;
  flake.darwinModules.development = developmentModule;
}
