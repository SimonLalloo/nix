{ pkgs, ... }:

{
  imports = [

    ./hyprland.nix
  ];

  home.packages = with pkgs; [

    spotify
    discord
    obsidian
  ];
}
