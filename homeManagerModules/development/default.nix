{ pkgs, ... }:

{
  imports = [

    ./python.nix
  ];

  home.packages = with pkgs; [

    rustup
    gcc
    lazygit
  ];
}
