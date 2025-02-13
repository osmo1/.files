{ config, sops, ... }:
{
  boot.supportedFilesystems = [ "btrfs" ];
  disko.devices = {
    disk.main = {
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
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
              passwordFile = "/tmp/disko-password";
              settings = {
                allowDiscards = true;
              };
              # Subvolumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # force overwrite
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
  };
}
