{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    desktop.photos.enable = mkEnableOption "Enable photo editing stuff";
  };

  config = mkIf config.desktop.photos.enable {

    home.packages = with pkgs; [

      nomacs # Photo viewing
      digikam # Photo sorting
      darktable # Photo editing
      focus-stack # Focus stacking util

      # TODO: figure out if I need these
      gvfs
      libraw
      gphoto2
      libmtp
      udisks2
    ];

  };
}
