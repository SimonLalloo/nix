{ config, lib, ... }:

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

        # Configuration for Eduroam
        ensureProfiles.profiles = {
          "eduroam" = {
            connection = {
              id = "eduroam";
              type = "wifi";
              autoconnect = true;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "eduroam";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-eap";
            };
            "802-1x" = {
              eap = "peap";
              identity = "sila3085@user.uu.se";
              password = "";
              phase2-auth = "mschapv2";
            };
            ipv4 = { method = "auto"; };
            ipv6 = { method = "auto"; };
          };
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
