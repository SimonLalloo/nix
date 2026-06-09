{ self, inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.myNushell = inputs.wrapper-modules.wrappers.nushell.wrap {
        inherit pkgs;
        "config.nu".content = ''
          $env.config = { show_banner: false }
          alias gg = git status -sb
        '';
      };
    };

  flake.nixosModules.nushell =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.shells.nushell.enable = lib.mkEnableOption "Enable nushell configuration";

      config = lib.mkIf config.shells.nushell.enable {
        environment.systemPackages = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.myNushell
          pkgs.carapace
        ];
      };
    };
}
