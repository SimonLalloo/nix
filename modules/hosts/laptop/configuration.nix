{ self, inputs, ... }:
{
  flake.nixosModules.laptopConfiguration =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.laptopHardware
        self.nixosModules.base

        self.nixosModules.networking
        self.nixosModules.bluetooth
        self.nixosModules.virtualisation

        self.nixosModules.neovim
        self.nixosModules.hyprland

        # Home Manager (to be migrated away from later)
        inputs.home-manager.nixosModules.default
      ];

      # Boot loader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      users.users.simon = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel" # sudo
          "networkmanager" # Networking
          "kvm" # Required for certain hardware acceleration

          # Virtualization stuff
          "libvirtd" # advanced virtualization management
          "docker" # Run docker without sudo
          "vboxusers" # Use VirtualBox
        ];
        packages = with pkgs; [ ];
      };

      # My default shell
      # TODO: Move to zsh module?
      programs.zsh.enable = true;

      networking.hostName = "laptop-nix";

      # DON'T CHANGE THIS
      system.stateVersion = "25.05";

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

      # TODO: Remove this
      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
          pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
        };
        users.simon = import ../../../hosts/laptop/home.nix;
      };
    };
}
