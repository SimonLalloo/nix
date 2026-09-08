{ self, inputs, ... }:
let
  gitModule =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.gh
        pkgs.delta
        pkgs.meld
        self.packages.${pkgs.stdenv.hostPlatform.system}.myGit
      ];
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
        inherit pkgs;
        configFile.content = builtins.readFile ./git/config;
        # core.pager / interactive.diffFilter shell out to delta, so pin it to
        # the wrapper's PATH instead of relying on the ambient environment.
        runtimePkgs = [ pkgs.delta ];
      };
    };

  flake.nixosModules.git = gitModule;
  flake.darwinModules.git = gitModule;
}
