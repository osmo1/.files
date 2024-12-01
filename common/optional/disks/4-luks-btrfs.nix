{
  boot.supportedFilesystems = [ "btrfs" ];
  disko.devices = {
    disk.main = {
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
          encrypted-root = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              passwordFile = "/tmp/disko-password";
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
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          encrypted-data = {
            size = "100%";
            content = {
              type = "luks";
              name = "data";
              passwordFile = "/tmp/disko-password";
              content = {
                type = "btrfs";
                extraArgs = [ 
                    "-f"
                    "/dev/mapper/media"
                ];
                subvolumes = {
                    "@" = { };
                    "@/data" = {
                      mountOptions = [
                        "subvol=data"
                        "noatime"
                      ];
                      mountpoint = "/home/osmo/data";
                    };
                };
              };
            };
          };
        };
      };
    };
    # Btrfs works in alphabethical order so tertiary with an a
    disk.aertiary = {
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          encrypted-media = {
            size = "100%";
            content = {
              type = "luks";
              name = "media";
              passwordFile = "/tmp/disko-password";
            };
          };
        };
      };
    };
    disk.mini = {
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          mini = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/osmo/mini";
              mountOptions = ["noatime"];
            };
          };
        };
      };
    };
  };
}
