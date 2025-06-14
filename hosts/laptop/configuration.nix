{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "laptop-nix";
    networkmanager = {
      enable = true;
      settings.connection = {
        # This is necessary for proper fallback to IPv4 in case of IPv6 issues.
        "ipv6.method" = "auto";
        "ipv6.may-fail" = true;
      };
    };
  };
  # Enable systemd-resolved for local DNS
  services.resolved.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

