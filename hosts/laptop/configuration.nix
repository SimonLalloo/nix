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
  # localizationConfig.enable = true;

  # Enable touchpad support
  services.libinput.enable = true;

  # Enable CUPS for printing
  services.printing.enable = true;

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
    packages = with pkgs; [ tree ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = { "simon" = import ./home.nix; };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Base utils
    vim
    wget
    git
    tmux
    dig
    btop
    stow
    zip
    unzip
    neovim

    # Fonts
    nerd-fonts.hack
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono

    # Term
    kitty

    # DE stuff
    rofi-wayland

    # Term stuff
    yazi

    # Apps
    obsidian
    discord
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT change this value.
  system.stateVersion = "25.05"; # Did you read the comment?
}

