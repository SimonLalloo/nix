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
        self.darwinModules.git
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      shells.zsh.enable = true;
      term.tmux.enable = true;

      environment.shellAliases.rebuild = "sudo darwin-rebuild switch --flake ~/nix#mbp-einride";

      users.users.simon = {
        name = "simon";
        home = "/Users/simon";
      };

      networking.hostName = "mbp-einride";
      system.stateVersion = 5;
    };
}
