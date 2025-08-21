{ pkgs, ... }:

{
  imports = [

    ./desktop

    ./development

    ./shells

    ./term
  ];

  home.packages = with pkgs; [ ];

  # File syncing
  services.syncthing.enable = true;
}
