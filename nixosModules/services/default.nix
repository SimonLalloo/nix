{ ... }:

{
  imports = [

    ./audio.nix

    ./bluetooth.nix

    ./networking.nix

    ./printing.nix

    ./ssh.nix
  ];

  # These handle mounting stuff when connecting external storage
  services.udisks2.enable = true;
  services.gvfs.enable = true;

}
