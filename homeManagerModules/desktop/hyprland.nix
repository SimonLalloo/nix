{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    desktop.hyprland.enable =
      mkEnableOption "Enable Hyprland user configuration";
  };

  # TODO:

  config = mkIf config.desktop.hyprland.enable {
    # User-specific Hyprland configuration
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Your personal Hyprland config goes here
        # "$mod" = "SUPER";

        bind = [
          # "$mod, Q, exec, kitty"
          # "$mod, C, killactive"
          # "$mod, M, exit"
          # "$mod, E, exec, yazi"
          # "$mod, V, togglefloating"
          # "$mod, R, exec, rofi -show drun"
          # "$mod, P, pseudo"
          # "$mod, J, togglesplit"
        ];

        # Add your keybinds, styling, animations, etc.
      };
    };

    # User applications for the desktop environment
    home.packages = with pkgs; [
      # hyprpaper # Wallpaper
      # hyprlock # Lock screen
      # hypridle # Idle manager

      rofi # App launcher / switcher
      kitty # terminal

      wl-clipboard # Clipboard manager

      grim # Screenshot tool
      slurp # Area selector
      imagemagick # Image editor
    ];

    # User services that should run with Hyprland
    # services.dunst.enable = true; # notifications
    # services.waybar.enable = true; # status bar
  };
}
