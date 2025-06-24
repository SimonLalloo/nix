{ config, lib, ... }:

with lib;

{
  options = {
    systemServices.bluetooth.enable = mkEnableOption "Enable bluetooth";
  };

  config = mkIf config.systemServices.bluetooth.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true; # GUI bluetooth manager
  };
}
