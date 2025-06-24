{ config, lib, pkgs, ... }:

with lib;

{
  options = { systemServices.audio.enable = mkEnableOption "Enable audio"; };

  config = mkIf config.systemServices.audio.enable {

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    environment.systemPackages = with pkgs;
      [

        pavucontrol # Audio control app
      ];
  };
}
