{ config, pkgs, ... }:

{
  imports = [ ../../homeManagerModules ];

  home.username = "simon";
  home.homeDirectory = "/home/simon";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs;
    [
      # Packages should be installed via modules

    ];

  desktop = {
    # TODO: fix hyperland config
    hyprland.enable = false;
    photos.enable = true;
    waybar.enable = true;
  };

  development = {
    python.enable = true; # base python will be installed even if disabled
    flutter.enable = true;
  };

  shells.zsh = {
    enable = true;
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos#laptop";
  };

  term.tmux.enable = true;

  home.sessionVariables = {
    # EDITOR = "emacs";
    PATH = "$PATH:$HOME/.cargo/bin";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  # DO NOT change this value, even when updating Home Manager.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
