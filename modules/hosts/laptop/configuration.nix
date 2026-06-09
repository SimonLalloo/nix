{ self, ... }:
{
  flake.nixosModules.laptopConfiguration =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.laptopHardware
        self.nixosModules.base
        self.nixosModules.term

        self.nixosModules.networking
        self.nixosModules.bluetooth
        self.nixosModules.virtualisation

        self.nixosModules.neovim
        self.nixosModules.hyprland
        self.nixosModules.niri

        self.nixosModules.desktop
        self.nixosModules.development
        self.nixosModules.shells
        self.nixosModules.tmux
      ];

      # Boot loader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      users.users.simon = {
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
          "kvm"
          "libvirtd"
          "docker"
          "vboxusers"
        ];
      };

      programs.zsh.enable = true;

      networking.hostName = "laptop-nix";

      # DON'T CHANGE THIS
      system.stateVersion = "25.05";

      # Critical kernel parameters for Tiger Lake
      boot.kernelParams = [ "acpi_osi=Linux" ];

      desktop.photos.enable = true;

      development = {
        python.enable = true;
        latex.enable = true;
      };

      shells = {
        zsh.enable = true;
        nushell.enable = true;
        rebuild = "sudo nixos-rebuild switch --flake ~/nixos#laptop";
      };

      term.tmux.enable = true;
    };
}
