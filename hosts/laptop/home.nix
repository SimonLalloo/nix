{ config, pkgs, ... }:

{
  imports = [ ../../homeManagerModules ];

  home.username = "simon";
  home.homeDirectory = "/home/simon";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [

    rustup
    gcc
  ];

  desktop = {
    # TODO: fix hyperland config
    hyprland.enable = false;
    photos.enable = true;
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

  # TODO: Clean this up
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
