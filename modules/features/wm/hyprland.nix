{ ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      services.libinput.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
      };

      environment.systemPackages = with pkgs; [
        wl-clipboard
        grim
        slurp
        imagemagick
        hyprpaper
        hyprlock
        hypridle
        brightnessctl
        rofi
      ];
    };
}
