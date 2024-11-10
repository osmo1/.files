{ config, ... }:
{
  boot.supportedFilesystems = [ "btrfs" ];
  disko.devices = {
    disk.main = {
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          root = {
            size = "100%";
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
    disk.secondary = {
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
            };
          };
	  games = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/osmo/Games";
              mountOptions = ["noatime"];
            };
          };
        };
      };
    };
  };
}
