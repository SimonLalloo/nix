{ self, ... }:
{
  flake.darwinModules.mbpSimonConfiguration =
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
        self.darwinModules.guiApps
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      shells.zsh.enable = true;
      term.tmux.enable = true;

      environment.shellAliases.rebuild = "sudo darwin-rebuild switch --flake ~/nix#mbp-simon";

      users.users.simon = {
        name = "simon";
        home = "/Users/simon";
      };

      networking.hostName = "mbp-simon";
      system.stateVersion = 5;
    };
}
