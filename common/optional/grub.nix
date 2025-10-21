{ config, ... }:
{
  boot = {
    initrd.systemd.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      # timeout = (if !config.hostSpec.isLaptop then 0 else 5);
      timeout = 5;
      grub = {
        enable = true;
        device = "nodev"; # GRUB menu generated without installing GRUB on a device

        efiSupport = true;
        useOSProber = true;
        # timeoutStyle = "hidden";
      };
    };
  };
}
