{ ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      # Touchpad support
      services.libinput.enable = true;

      # XDG portal for Hyprland
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard # Clipboard manager
        grim # Screenshot tool
        slurp # Area selector
        imagemagick # Image editor
        hyprpaper # Wallpaper
        hyprlock # Lock screen
        hypridle # Idle manager
        brightnessctl # Backlight controls
        rofi # Application launcher / app switcher
        kitty # Default terminal
      ];
    };
}
