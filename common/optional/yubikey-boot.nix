{
  boot.initrd.kernelModules = [
    "vfat"
    "nls_cp437"
    "nls_iso8859-1"
    "usbhid"
  ];

  #boot.initrd.luks.yubikeySupport = true;

  boot.initrd.luks.devices = {
    "crypted" = {
      preLVM = true;
      yubikey = {
        slot = 3;
        twoFactor = false;
        storage = {
          device = "/dev/nvme0n1p3";
        };
      };
    };
  };
}
