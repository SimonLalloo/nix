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

      libraw # Library for raw photo handling
      gphoto2 # Set of camera tools
    ];

  };
}
