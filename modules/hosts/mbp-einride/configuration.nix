{ self, inputs, ... }:
{
  flake.darwinModules.mbpEinrideConfiguration =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = "aarch64-darwin";

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
          neovim
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
