{ lib, ... }:
{
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
    description = "Modules for nix-darwin, merged across flake-parts modules.";
  };
}
