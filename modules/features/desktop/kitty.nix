{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.myKitty = inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;
        font = {
          name = "Hack Nerd Font Mono";
          size = 12;
        };
        settings = {
          enable_audio_bell = false;
          scrollback_lines = 10000;
          update_check_interval = 0;
        };
      };
    };
}
