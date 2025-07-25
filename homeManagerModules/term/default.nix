{ pkgs, ... }:

{
  imports = [ ./tmux.nix ];

  home.packages = with pkgs; [ ];
}
