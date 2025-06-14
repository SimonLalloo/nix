{ config, lib, ... }:

with lib;

{
  options = {
    systemServices.printing.enable = mkEnableOption "Enable printing";
  };

  config = mkIf config.systemServices.printing.enable {
    # Enable CUPS for printing
    services.printing.enable = true;
  };
}
