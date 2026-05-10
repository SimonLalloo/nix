{ self, inputs, ... }:
{
  flake.nixosModules.laptopConfiguration =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.laptopHardware
        self.nixosModules.neovim
        inputs.home-manager.nixosModules.default

        # Existing classic-style NixOS modules tree (untouched for now)
        ../../../nixosModules
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

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
          "docker" # Run docker without sudo
          "vboxusers" # Use VirtualBox
        ];
        packages = with pkgs; [ ];
      };

      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
          pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
        };
        users.simon = import ../../../hosts/laptop/home.nix;
      };

      hyprland.enable = true;

      fonts.enable = true;

      services.printing.enable = true;
      # Enable the OpenSSH daemon.
      services.openssh.enable = true;
      # These handle mounting stuff when connecting external storage
      services.udisks2.enable = true;
      services.gvfs.enable = true;

      services.blueman.enable = true; # GUI bluetooth manager
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            Experimental = true; # Better BLE support.
            FastConnectable = true; # Faster connections but more connections.
          };
          GATT = {
            AttMtu = 517;
          };
          Policy = {
            # Enable all controllers when they are found. This includes
            # adapters present on start as well as adapters that are plugged
            # in later on. Defaults to 'true'.
            AutoEnable = true;
          };
        };
      };

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
      };

      virtualisation.docker.enable = true;
      virtualisation.virtualbox.host.enable = true;

      # Hardware acceleration for Android emulator (essential for performance)
      virtualisation.libvirtd.enable = true;
      boot.kernelModules = [
        "kvm-intel" # Use "kvm-amd" for AMD processors
      ];
      boot.extraModprobeConfig = "options kvm_intel nested=1";

      # Graphics acceleration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # Critical kernel parameters for Tiger Lake
      # This fixes some crashing issues, but probably isn't
      # great for battery optimization.
      # I'm not sure how well this works or which params
      # are important or not, but not using them seems fine.
      boot.kernelParams = [
        # "i915.enable_psr=0" # Disable Panel Self Refresh (most important)
        # "i915.enable_guc=0" # Disable GuC submission
        # "i915.enable_huc=0" # Disable HuC firmware
        # "i915.enable_fbc=0" # Disable framebuffer compression
        # "i915.force_probe=9a49" # Force probe for Tiger Lake (optional)
        "acpi_osi=Linux" # Inform BIOS of OS
      ];

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };

      programs.firefox.enable = true;

      networking = {
        hostName = "laptop-nix";

        networkmanager = {
          enable = true;
          settings.connection = {
            # This is necessary for proper fallback to IPv4 in case of IPv6 issues.
            "ipv6.method" = "auto";
            "ipv6.may-fail" = true;
          };

          # Configuration for Eduroam
          ensureProfiles.profiles = {
            "eduroam" = {
              connection = {
                id = "eduroam";
                type = "wifi";
                autoconnect = true;
              };
              wifi = {
                mode = "infrastructure";
                ssid = "eduroam";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-eap";
              };
              "802-1x" = {
                eap = "peap";
                identity = "sila3085@user.uu.se";
                password = "";
                phase2-auth = "mschapv2";
              };
              ipv4 = {
                method = "auto";
              };
              ipv6 = {
                method = "auto";
              };
            };
          };
        };
      };

      # Enable systemd-resolved for local DNS
      services.resolved.enable = true;

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # TODO: refactor this
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

        pavucontrol
      ];

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      # DO NOT change this value.
      system.stateVersion = "25.05"; # Did you read the comment?
    };
}
