{
  boot = {
    initrd.systemd.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      grub = {
        enable = true;
        device = "nodev"; # GRUB menu generated without installing GRUB on a device

        efiSupport = true;
        useOSProber = true;
        timeoutStyle = "hidden";
      };
    };
  };

  # For dual-booting time issues
  time.hardwareClockInLocalTime = true;
}
