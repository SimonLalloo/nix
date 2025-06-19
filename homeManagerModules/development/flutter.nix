{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    development.flutter.enable = mkEnableOption "Enable Flutter/Dart dev stuff";
  };

  config = mkIf config.development.flutter.enable {

    home.packages = with pkgs; [ android-studio ];
  };
}
