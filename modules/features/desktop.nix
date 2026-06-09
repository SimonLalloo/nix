{ ... }:
{
  flake.nixosModules.desktop =
    { pkgs, lib, config, ... }:
    {
      options = {
        desktop.photos.enable = lib.mkEnableOption "Enable photo editing tools";
      };

      config = {
        environment.systemPackages =
          with pkgs;
          [
            spotify
            discord
            obsidian
            zoom-us
            thunar
            pdfpc
            dunst
          ]
          ++ lib.optionals config.desktop.photos.enable [
            nomacs
            digikam
            darktable
            focus-stack
            libraw
            gphoto2
          ];

        services.syncthing = {
          enable = true;
          user = "simon";
          dataDir = "/home/simon";
          configDir = "/home/simon/.config/syncthing";
        };
      };
    };
}
