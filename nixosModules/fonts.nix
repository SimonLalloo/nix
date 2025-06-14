{ config, lib, pkgs, ... }:

with lib;

{
  options = { fonts.enable = mkEnableOption "Enable custom fonts"; };

  config = mkIf config.fonts.enable {
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
  };
}
