{ self, inputs, ... }:
{
  flake.darwinModules.mbpEinrideConfiguration =
    { pkgs, lib, inputs, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;

      environment.systemPackages =
        (with pkgs; [
          # Terminal tools
          gh
          claude-code
          ripgrep
          fzf

          # Shells
          carapace

          # Dev tools
          helix
          rustup
          gcc
          lazygit
          stylua
          tree-sitter
          harper
          nodejs-slim
          jdk
          fd
          gnumake
        ])
        ++ [
          inputs.nvf-config.packages.${pkgs.stdenv.hostPlatform.system}.default
          # self.packages.aarch64-darwin.myNushell
          self.packages.aarch64-darwin.myTmux
        ];

      users.users.simon = {
        name = "simon";
        home = "/Users/simon";
        shell = self.packages.aarch64-darwin.myZsh;
      };
      environment.shells = [ self.packages.aarch64-darwin.myZsh ];
      programs.zsh.enable = true;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      networking.hostName = "mbp-einride";
      system.stateVersion = 5;
    };
}
