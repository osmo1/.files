{
  pkgs,
  lib,
  ...
}:
{
  boot.initrd = {
    network = {
      enable = true;
    };

    # Network card drivers. Check `lshw` if unsure.
    kernelModules = [ "r8169" ];
    # TODO(maybe): I'd love to have these somehow "auto filled" but no idea how. 
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

  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
}
