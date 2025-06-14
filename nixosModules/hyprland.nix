{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    hyprland.enable = mkEnableOption "Enable Hyprland desktop environment";
  };

  config = mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Enable touchpad support
    services.libinput.enable = true;

    environment.systemPackages = with pkgs;
      [
        rofi-wayland # Application launcher / app switcher
      ];

    # Enable XDG portal for Hyprland
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    };
  };
}
