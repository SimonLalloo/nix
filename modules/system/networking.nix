{ ... }:
{
  flake.nixosModules.networking = {
    networking.networkmanager = {
      enable = true;
      settings.connection = {
        # Necessary for proper fallback to IPv4 in case of IPv6 issues.
        "ipv6.method" = "auto";
        "ipv6.may-fail" = true;
      };

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
          ipv4.method = "auto";
          ipv6.method = "auto";
        };
      };
    };

    # Local DNS
    services.resolved.enable = true;
  };
}
