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
    thunar # File manager
    pdfpc # PDF presentation software
    dunst
  ];
}
