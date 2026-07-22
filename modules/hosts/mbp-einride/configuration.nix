{ self, ... }:
{
  flake.darwinModules.mbpEinrideConfiguration =
    { ... }:
    {
      imports = [
        self.darwinModules.nixSettings

        self.darwinModules.term
        self.darwinModules.direnv

        self.darwinModules.zsh
        self.darwinModules.tmux

        self.darwinModules.neovim
        self.darwinModules.development
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      shells.zsh.enable = true;
      term.tmux.enable = true;

      # Workaround: nix-darwin master (a1fa429, 2026-06-18) builds its HTML
      # manual with `nixos-render-docs manual html --toc-depth`, but the
      # nixos-unstable bump (2026-07-05) removed that flag in favour of
      # `--sidebar-depth`, breaking darwin-manual-html / darwin-help.
      # Man pages use a different subcommand and are unaffected.
      # The darwin-uninstaller does an isolated nested darwin eval with docs
      # at their default, so it rebuilds the manual independently — disable it
      # too (still runnable ad-hoc via `nix run`).
      # Remove both once nix-darwin catches up to the new nixos-render-docs CLI.
      documentation.doc.enable = false;
      system.tools.darwin-uninstaller.enable = false;

      environment.shellAliases.rebuild = "sudo darwin-rebuild switch --flake ~/nix#mbp-einride";

      users.users.simon = {
        name = "simon";
        home = "/Users/simon";
      };

      networking.hostName = "mbp-einride";
      system.stateVersion = 5;
    };
}
