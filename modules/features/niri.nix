{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };
    };

  # TODO: Separate niri config from perSystem module

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          input = {
            focus-follows-mouse = { };

            keyboard = {
              xkb = {
                layout = "us,se";
                options = "grp:alt_shift_toggle,ctrl:nocaps";
              };
            };

            touchpad = {
              # natural-scroll = {};
              tap = { };
            };
          };

          outputs."eDP-1".scale = 1.0;

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          layout = {
            gaps = 5;

            focus-ring = {
              width = 4;
              active-color = "#b8bb26";
            };
          };

          prefer-no-csd = true;

          # Belt-and-suspenders: force outline-style drawing for every window,
          # including apps that ignore prefer-no-csd.
          window-rules = [
            {
              draw-border-with-background = false;
            }
          ];

          window-rule = {
            geometry-corner-radius = 10;
            clip-to-geometry = true;
          };

          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+C".close-window = { };
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

            "Mod+H".focus-column-left = { };
            "Mod+L".focus-column-right = { };
            "Mod+K".focus-window-up = { };
            "Mod+J".focus-window-down = { };

            "Mod+Left".focus-column-left = { };
            "Mod+Right".focus-column-right = { };
            "Mod+Up".focus-window-up = { };
            "Mod+Down".focus-window-down = { };

            "Mod+Shift+H".move-column-left = { };
            "Mod+Shift+L".move-column-right = { };
            "Mod+Shift+K".move-window-up = { };
            "Mod+Shift+J".move-window-down = { };

            "Mod+Ctrl+H".set-column-width = "-5%";
            "Mod+Ctrl+L".set-column-width = "+5%";
            "Mod+Ctrl+J".set-window-height = "-5%";
            "Mod+Ctrl+K".set-window-height = "+5%";

            # FIXME: These don't work
            "Mod+1".focus-workspace = "w0";
            "Mod+2".focus-workspace = "w1";
            "Mod+3".focus-workspace = "w2";
            "Mod+4".focus-workspace = "w3";
            "Mod+5".focus-workspace = "w4";
            "Mod+6".focus-workspace = "w5";
            "Mod+7".focus-workspace = "w6";
            "Mod+8".focus-workspace = "w7";
            "Mod+9".focus-workspace = "w8";
            "Mod+0".focus-workspace = "w9";

            "Mod+Shift+1".move-column-to-workspace = "w0";
            "Mod+Shift+2".move-column-to-workspace = "w1";
            "Mod+Shift+3".move-column-to-workspace = "w2";
            "Mod+Shift+4".move-column-to-workspace = "w3";
            "Mod+Shift+5".move-column-to-workspace = "w4";
            "Mod+Shift+6".move-column-to-workspace = "w5";
            "Mod+Shift+7".move-column-to-workspace = "w6";
            "Mod+Shift+8".move-column-to-workspace = "w7";
            "Mod+Shift+9".move-column-to-workspace = "w8";
            "Mod+Shift+0".move-column-to-workspace = "w9";

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            # TODO: brightness controls

            # TODO: screenshots

          };

          workspaces =
            let
              settings = {
                layout.gaps = 5;
              };
            in
            {
              "w0" = settings;
              "w1" = settings;
              "w2" = settings;
              "w3" = settings;
              "w4" = settings;
              "w5" = settings;
              "w6" = settings;
              "w7" = settings;
              "w8" = settings;
              "w9" = settings;
            };

        };
      };
    };
}
