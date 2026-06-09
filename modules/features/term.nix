{ ... }:
{
  flake.nixosModules.term =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh # GitHub
        claude-code

        git
        tree
        ripgrep
        fzf
        tmux
        zip
        unzip
      ];
    };
}
