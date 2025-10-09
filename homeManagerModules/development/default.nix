{ pkgs, ... }:

{
  imports = [

    ./python.nix

    ./latex.nix
  ];

  home.packages = with pkgs; [

    vscode-fhs

    rustup
    gcc
    lazygit

    # This is needed for neovim stuff
    # TODO: Make a separate flake for nvim

    # LSPS and similar
    stylua
    tree-sitter
    kdePackages.qtdeclarative # QML LSP
    # PARTS
    nodejs-slim
    jdk
    # TOOLING
    ripgrep # Better grep
    fd # Better find
  ];
}
