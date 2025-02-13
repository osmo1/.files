{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot.initrd = {
    network = {
      enable = true;
    };
    # Network card drivers. Check `lshw` if unsure.
    kernelModules = [ "r8169" ];
    clevis = {
      enable = true;
      useTang = true;
      devices = {
        crypted.secretFile = ../../.secrets/jwt.jwt;
        media.secretFile = ../../.secrets/jwt.jwt;
        data.secretFile = ../../.secrets/jwt.jwt;
      };
    };
    luks.devices = lib.mkForce {
      crypted.device = "/dev/nvme0n1p4";
      media.device = "/dev/sda1";
      data.device = "/dev/sdb1";
    };
  };
  environment.systemPackages = [ pkgs.clevis ];
  # Your post-boot network configuration is taken
  # into account. It should contain:
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
}
