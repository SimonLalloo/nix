{ pkgs, ... }:

{
  imports = [

    ./hyprland.nix

    ./photos.nix

    ./waybar.nix
  ];

  home.packages = with pkgs; [

    spotify
    discord
    obsidian
    zoom-us
    xfce.thunar # File manager

    dunst
    quickshell
  ];
}
