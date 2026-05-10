{ ... }:
{
  # NOTE: kvm-intel assumes an Intel CPU. For AMD use "kvm-amd".
  flake.nixosModules.virtualisation = {
    virtualisation.docker.enable = true;
    virtualisation.virtualbox.host.enable = true;
    virtualisation.libvirtd.enable = true;
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModprobeConfig = "options kvm_intel nested=1";
  };
}
