{ ... }:
{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      # Nix daemon settings
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };

      nixpkgs.config.allowUnfree = true;

      # Locale & timezone
      time.timeZone = "Europe/Stockholm";

      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "sv_SE.UTF-8";
        LC_IDENTIFICATION = "sv_SE.UTF-8";
        LC_MEASUREMENT = "sv_SE.UTF-8";
        LC_MONETARY = "sv_SE.UTF-8";
        LC_NAME = "sv_SE.UTF-8";
        LC_NUMERIC = "sv_SE.UTF-8";
        LC_PAPER = "sv_SE.UTF-8";
        LC_TELEPHONE = "sv_SE.UTF-8";
        LC_TIME = "sv_SE.UTF-8";
      };

      # Fonts
      fonts.packages = with pkgs; [
        nerd-fonts.hack
        nerd-fonts.noto
        nerd-fonts.jetbrains-mono
      ];

      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "Hack Nerd Font" ];
        };
      };

      # Graphics acceleration
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # Audio (pipewire)
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        # jack.enable = true;
      };

      # Common services
      services.printing.enable = true;
      services.openssh.enable = true;
      services.udisks2.enable = true; # Mount external storage on connect
      services.gvfs.enable = true;

      programs.firefox.enable = true;

      environment.systemPackages = with pkgs; [
        # Base utilities
        btop
        dig
        git
        stow
        tmux
        tree
        unzip
        vim
        wget
        yazi
        zip

        # Audio GUI
        pavucontrol
      ];
    };
}
