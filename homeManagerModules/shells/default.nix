{ ... }:

{
  imports = [ ./zsh.nix ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
