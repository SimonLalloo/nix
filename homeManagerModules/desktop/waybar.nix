{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    desktop.waybar.enable = mkEnableOption "Enable waybar config";
    desktop.waybar.fontSize = mkOption {
      type = types.int;
      default = 14;
      description = "Font size for Waybar";
    };
  };

  config = mkIf config.desktop.waybar.enable {

    home.packages = with pkgs;
      [

      ];

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "network" "battery" "tray" ];

          "hyprland/workspaces" = { format = "{name}"; };

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d, %Y (%R)}";
            tooltip-format = "<tt><big>{calendar}</big></tt>";
          };

          # Add other module configurations...
        };
      };

      style = ''
        * {
          font-family: "JetBrains Mono";
          font-size: ${toString config.desktop.waybar.fontSize}px;
        }

        window#waybar {
          background-color: rgba(0, 0, 0, 0.7);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #ffffff;
        }
      '';
    };
  };
}
