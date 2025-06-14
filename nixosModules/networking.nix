{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    networkingConfig.enable =
      mkEnableOption "Enable laptop networking configuration";
  };

  config = mkIf config.networkingConfig.enable {
    networking = {
      # TODO: pass this as an option
      hostName = "laptop-nix";

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
