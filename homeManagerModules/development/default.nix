{ pkgs, ... }:

{
  imports = [

    ./python.nix

    ./latex.nix
  ];

  home.packages = with pkgs; [

    helix

    vscode-fhs

    rustup
    gcc
    lazygit

    # This is needed for neovim stuff
    # TODO: Make a separate flake for nvim

    # LSPs and similar
    stylua
    tree-sitter
    kdePackages.qtdeclarative # QML LSP
    harper # Spelling/grammar checker
    # PARTS
    nodejs-slim
    jdk
    # TOOLING
    ripgrep # Better grep
    fd # Better find

    gnumake
    linuxPackages_latest.perf
  ];
}
