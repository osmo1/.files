{
  lib,
  config,
  pkgs,
  ...
}:
{
  /*
    #sops.secrets.test.path = "/home/osmo/testse";
      sops.secrets.open-wrt = {
        path = "/boot/key";
      };
      boot.initrd.network.enable = true;
      boot.initrd.systemd = {
        enable = true;
        services.remote-crypt = {
      description = "Fetch LUKS passphrase and unlock disk";
      wantedBy = [
            "initrd.target"
    	"initrd-fs.target"
    	"initrd-root-device.target"
    	"systemd-vconsole-setup.service"
    	"restore-root.service"
    	"systemd-cryptsetup@crypted.service"
      ];
            requires = [ "network-online.target" ] ++ ( if config.networking.hostName == "testeri"
    	  then [ "dev-disk-by\\x2dpartlabel-disk\\x2dsecondary\\x2dencrypted\\x2droot.device" ]
    	  else [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2dcrypted.device" ]);
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      requiredBy = [
            "initrd.target"
    	"initrd-fs.target"
    	"initrd-root-device.target"
    	"systemd-vconsole-setup.service"
    	"restore-root.service"
    	"systemd-cryptsetup@crypted.service"
    	#"cryptsetup-pre.target"
    	#"cryptsetup.target"
      ];

      serviceConfig = {
        ExecStart = ''
          echo "Fetching LUKS passphrase from 192.168.11.2..."
          passphrase=$(ssh -i /boot/key keyuser@192.168.11.2)

          echo "$passphrase" > /etc/luks-passphrase
          chmod 600 /etc/luks-passphrase

          cryptsetup open /dev/disk/by-partlabel/disk-main-crypted crypted --key-file /etc/luks-passphrase
          rm -rf /etc/luks-passphrase
        '';
        Type = "oneshot";
        RemainAfterExit = true;
      };
        };
      };
      /*boot.initrd.network.postCommands = ''
          echo "Fetching LUKS passphrase from 192.168.11.2..."
          passphrase=$(ssh -i /boot/key keyuser@192.168.11.2)

          echo "$passphrase" > /etc/luks-passphrase
          chmod 600 /etc/luks-passphrase

          cryptsetup open /dev/disk/by-partlabel/disk-main-crypted crypted --key-file /etc/luks-passphrase; then
          rm -rf /etc/luks-passphrase
        '';
  */
}
