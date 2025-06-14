{ config, lib, ... }:

with lib;

{
  options = { systemServices.ssh.enable = mkEnableOption "Enable ssh"; };

  config = mkIf config.systemServices.ssh.enable {
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  };
}
