{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../nixosModules
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networkingConfig.enable = true;

  # TODO: refactor to separate file
  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Define user account.
  users.users.simon = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # Networking
    ];
    packages = with pkgs; [ ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "simon" = import ./home.nix; };
  };

  hyprland.enable = true;

  fonts.enable = true;

  systemServices = {
    printing.enable = true;
    ssh.enable = true;
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Base utils
    btop
    dig
    git
    stow
    tmux
    tree
    unzip
    vim
    wget
    zip

    # Term
    kitty

    # Term stuff
    yazi
    neovim

    # Apps
    obsidian
    discord
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT change this value.
  system.stateVersion = "25.05"; # Did you read the comment?
}

