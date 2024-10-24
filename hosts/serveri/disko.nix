{
  deviceMain ? throw "Set this to your first disk device, e.g. /dev/sda",
  deviceSecondary ? throw "Set this to your second disk device, e.g. /dev/sdb",
  ...
}:
{
  disko.devices = {
    disk.main = {
      device = deviceMain;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = "8G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          nix = {
            name = "nix";
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/nix";
              mountOptions = [ "noatime" ];
            };
          };
        };
      };
    };
    disk.secondary = {
      device = deviceSecondary;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                };
                "/persist" = {
                  mountOptions = [
                    "subvol=persist"
                    "noatime"
                  ];
                  mountpoint = "/persist";
                };
                "/home" = {
                  mountOptions = [
                    "subvol=home"
                    "noatime"
                  ];
                  mountpoint = "/home/osmo";
                };
              };
            };
          };
        };
      };
    };
  };
}
