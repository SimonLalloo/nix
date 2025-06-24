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

  # TODO: 
  # - Audio
  # - Bluetooth
  # - Battery

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  programs.zsh.enable = true;

  # Define user account.
  users.users.simon = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # sudo
      "networkmanager" # Networking
      "adbusers" # Required for ADB (Android Debug Bridge) device access
      "kvm" # Required for Android emulator hardware acceleration
      "libvirtd" # advanced virtualization management
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
    audio.enable = true;
    networking = {
      enable = true;
      hostname = "laptop-nix";
    };
    printing.enable = true;
    ssh.enable = true;
  };

  # Hardware acceleration for Android emulator (essential for performance)
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-intel" ]; # Use "kvm-amd" for AMD processors
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  # Graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d --delete-generations +10";
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

    # Hyprland stuff
    wl-clipboard # Clipboard manager
    grim # Screenshot tool
    slurp # Area selector
    imagemagick # Image editor
    hyprpaper # Wallpaper
    hyprlock # Lock screen
    hypridle # Idle manager
    brightnessctl # Backlight controls
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT change this value.
  system.stateVersion = "25.05"; # Did you read the comment?
}

