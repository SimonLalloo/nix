{ ... }:
{
  flake.nixosModules.term =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        claude-code
        ripgrep
        fzf
      ];
    };
}
