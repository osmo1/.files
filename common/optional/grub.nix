{ config, pkgs, ... }:
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
          useOSProber = true; # Enable detection for other OS, such as Windows Boot Manager
          timeoutStyle = "hidden";

          # Extra menu entries for NixOS (latest) and NixOS Generations
          /*
            extraEntries = ''
              # Slot One: Latest NixOS Generation
              menuentry "NixOS (latest)" {
                search --set=root --file /boot/grub/grub.cfg
                configfile /boot/grub/grub.cfg
              }

              # Slot Three: NixOS Generations (submenu)
              menuentry "NixOS Generations" {
                search --set=root --file /boot/grub/grub.cfg
                configfile /boot/grub/grub.cfg
              }
            '';
          */
        };
    };
  };
  time.hardwareClockInLocalTime = true;
}
