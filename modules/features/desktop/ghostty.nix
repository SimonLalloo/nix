{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      ghosttyConfig = pkgs.writeText "ghostty-config" ''
        theme = GruvboxDark
        font-family = Hack Nerd Font Mono
        font-size = 12
      '';
    in
    {
      packages.myGhostty = pkgs.symlinkJoin {
        name = "ghostty-wrapped";
        paths = [ pkgs.ghostty ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/ghostty \
            --add-flags "--config-file=${ghosttyConfig}"
        '';
      };
    };

  flake.nixosModules.ghostty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGhostty
      ];
    };
}
