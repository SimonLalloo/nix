{ self, ... }:
{
  flake.nixosModules.laptopConfiguration =
    { ... }:
    {
      imports = [
        self.nixosModules.laptopHardware
        self.nixosModules.nixSettings
        self.nixosModules.base
        self.nixosModules.term

        self.nixosModules.networking
        self.nixosModules.bluetooth
        self.nixosModules.virtualisation

        self.nixosModules.neovim
        self.nixosModules.hyprland
        self.nixosModules.niri

        self.nixosModules.desktop
        self.nixosModules.kitty
        self.nixosModules.ghostty
        self.nixosModules.development
        self.nixosModules.developmentLinux

        self.nixosModules.zsh
        self.nixosModules.nushell
        self.nixosModules.tmux
        self.nixosModules.direnv
      ];

      # Boot loader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      users.users.simon = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "kvm"
          "libvirtd"
          "docker"
          "vboxusers"
        ];
      };

      networking.hostName = "laptop-nix";

      # DON'T CHANGE THIS
      system.stateVersion = "25.05";

      # Critical kernel parameters for Tiger Lake
      boot.kernelParams = [ "acpi_osi=Linux" ];

      desktop.photos.enable = true;

      development = {
        python.enable = true;
      };

      shells.zsh.enable = true;
      shells.nushell.enable = true;

      programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch --flake ~/nixos#laptop";

      term.tmux.enable = true;
    };
}
