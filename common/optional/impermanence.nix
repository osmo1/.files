{ config, ... }:
{
  # TODO: Impermanence got fucked up somewhere along the way and now i'm scared to use it. 
  # Needs a proper fix
  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    systemd.enable = true;
    systemd.services.restore-root = {
      description = "Rollback btrfs rootfs";
      wantedBy = [ "initrd.target" ];
      requires = (
        if config.networking.hostName == "testeri" then
          [ "dev-disk-by\\x2dpartlabel-disk\\x2dsecondary\\x2dencrypted\\x2droot.device" ]
        else
          [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2dcrypted.device" ]
      );
      after =
        [ "systemd-cryptsetup@crypted.service" ]
        ++ (
          if config.networking.hostName == "testeri" then
            [ "dev-disk-by\\x2dpartlabel-disk\\x2dsecondary\\x2dencrypted\\x2droot.device" ]
          else
            [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2dcrypted.device" ]
        );
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /btrfs_tmp
        mount -o subvol="@" /dev/mapper/crypted /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
        	mkdir -p /btrfs_tmp/old_roots
        	timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        	mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
            fi

            delete_subvolume_recursively() {
        	IFS=$'\n'
        	for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        	    delete_subvolume_recursively "/btrfs_tmp/$i"
        	done
        	btrfs subvolume delete "$1"
            }

            for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        	delete_subvolume_recursively "$i"
            done

            btrfs subvolume create /btrfs_tmp/root
            umount /btrfs_tmp
      '';
    };
  };

  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/ssh"
      "/var/lib/nixos"
      #"/home/osmo/"
    ] ++ (if config.virtualisation.podman.enable then [ "/etc/containers/" ] else [ ]);
    files = [ "/etc/machine-id" ];
  };
  systemd.tmpfiles.rules = [
    "d /persist/home 0777 root root -"
    "d /persist/home/osmo 0770 osmo users -"
  ];
}
