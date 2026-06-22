{ ... }:
{
  flake.nixosModules.developmentLinux =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vscode-fhs
        kdePackages.qtdeclarative
      ];
    };
}
