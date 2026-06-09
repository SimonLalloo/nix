{ ... }:
{
  flake.nixosModules.development =
    { pkgs, lib, config, ... }:
    {
      options = {
        development.python.enable = lib.mkEnableOption "Enable Python development environment";
        development.latex.enable = lib.mkEnableOption "Enable LaTeX development environment";
      };

      config.environment.systemPackages =
        with pkgs;
        [
          helix
          vscode-fhs
          rustup
          gcc
          lazygit
          stylua
          tree-sitter
          kdePackages.qtdeclarative
          harper
          nodejs-slim
          jdk
          fd
          gnumake
        ]
        ++ lib.optionals config.development.python.enable [
          ruff
          pyright
          (python3.withPackages (ps: with ps; [
            numpy
            matplotlib
            pip
          ]))
        ]
        ++ lib.optionals config.development.latex.enable [
          texlive.combined.scheme-full
          zathura
          texlab
          ltex-ls
        ];
    };
}
