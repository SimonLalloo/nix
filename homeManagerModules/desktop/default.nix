{ pkgs, ... }:

{
  imports = [

    ./hyprland.nix

    ./photos.nix
  ];

  home.packages = with pkgs; [

    spotify
    discord
    obsidian
    zoom-us
    xfce.thunar
  ];
}
