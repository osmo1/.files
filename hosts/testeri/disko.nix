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
	      mountOptions = [
		"defaults"
	      ]; 
            };
          };
          swap = {
            size = "16G";
            content = {
              type = "swap";
	      randomEncryption = true;
            };
          };
          home_shared = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/home/shared";
              mountOptions = ["noatime"];
            };
          };
        };
      };
    };
    disk.secondary = {
      device = "/dev/vdb";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          encrypted-root = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
		  "@" = {};
                  "@/root" = {
                    mountpoint = "/";
                  };
                  "@/nix" = {
                    mountOptions = ["subvol=nix" "noatime"];
                    mountpoint = "/nix";
                  };
                  "@/persist" = {
                    mountOptions = ["subvol=persist" "noatime"];
                    mountpoint = "/persist";
                  };
                  "@/home" = {
                    mountOptions = ["subvol=home" "noatime"];
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

