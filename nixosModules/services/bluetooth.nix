{ config, lib, ... }:

with lib;

{
  options = {
    systemServices.bluetooth.enable = mkEnableOption "Enable bluetooth";
  };

  config = mkIf config.systemServices.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true; # Better BLE support.
          FastConnectable = true; # Faster connections but more connections.
        };
        GATT = {
          AttMtu = 517;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
    };

    services.blueman.enable = true; # GUI bluetooth manager
  };
}
