{ ... }:
let
  macModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
      ];
    };
in
{
  flake.darwinModules.mac = macModule;
}
