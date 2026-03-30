{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  imports = [

    ./zsh.nix
    ./nushell.nix
  ];

  options = {
    shells.rebuild = mkOption {
      type = types.str;
      default = "echo command not set";
      description = "Rebuild command for the device";
    };
  };

  config = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
