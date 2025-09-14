{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    development.latex.enable = mkEnableOption "Enable latex dev env";
  };

  config = mkIf config.desktop.waybar.enable {

    home.packages = with pkgs; [
      texlive.combined.scheme-full

      zathura # PDF viewer

      texlab # LaTeX Language Server for LSP support
      ltex-ls # Grammar/spell checking language server
    ];
  };
}
