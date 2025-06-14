{ ... }:

{
  imports = [
    ./networking.nix

    ./localization.nix

    ./hyprland.nix

    ./fonts.nix

    ./services
  ];
}
