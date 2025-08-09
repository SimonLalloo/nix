{ pkgs, ... }:

{
  imports = [

    ./python.nix
    ./flutter.nix
  ];

  home.packages = with pkgs; [

    rustup
    gcc
    lazygit
  ];
}
