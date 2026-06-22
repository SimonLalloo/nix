{ ... }:
let
  termModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        claude-code

        ripgrep
        fzf
      ];
    };
in
{
  flake.nixosModules.term = termModule;
  flake.darwinModules.term = termModule;
}
