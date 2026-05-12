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
              natural-scroll = { };
              tap = { };
            };
          };

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          layout.gaps = 5;

          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+C".close-window = { };
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          };
        };
      };
    };
}
