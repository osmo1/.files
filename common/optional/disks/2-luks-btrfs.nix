{
  boot.supportedFilesystems = [ "btrfs" ];
  disko.devices = {
    disk.main = {
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
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "defaults" ];
            };
          };
          swap = {
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          };
          crypted = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = { };
                  "@/root" = {
                    mountpoint = "/";
                  };
                  "@/nix" = {
                    mountOptions = [
                      "subvol=nix"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  "@/persist" = {
                    mountOptions = [
                      "subvol=persist"
                      "noatime"
                    ];
                    mountpoint = "/persist";
                  };
                  "@/home" = {
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
    disk.secondary = {
      content = {
        type = "gpt";
        partitions = {
          crypted-extra = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted-extra";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@/extra" = {
                    mountOptions = [
                      "subvol=extra"
                      "noatime"
                    ];
                    mountpoint = "/home/osmo/extra";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
