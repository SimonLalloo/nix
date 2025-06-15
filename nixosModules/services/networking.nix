{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    systemServices.networking.enable =
      mkEnableOption "Enable networking configuration";

    systemServices.networking.hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = "Hostname for the device";
    };
  };

  config = mkIf config.systemServices.networking.enable {
    networking = {
      hostName = config.systemServices.networking.hostname;

      networkmanager = {
        enable = true;
        settings.connection = {
          # This is necessary for proper fallback to IPv4 in case of IPv6 issues.
          "ipv6.method" = "auto";
          "ipv6.may-fail" = true;
        };
      };
    };

    # Enable systemd-resolved for local DNS
    services.resolved.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
