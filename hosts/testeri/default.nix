{ config, lib, configLib, pkgs, pkgs-unstable, nixvim, inputs, nur, ... }:

{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
	      ../../common/optional/impermanence.nix
	      ../../common/optional/notes.nix
	      #../../common/optional/sddm.nix
	#../../common/optional/dwl
      #../../common/optional/podman.nix
      #../../common/optional/samba.nix
    ];

    system.stateVersion = "24.05";

    networking.hostName = "testeri";

    #TODO: Find a better place for this
    # common/core ?
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
	systemd-boot.enable = true;
	systemd-boot.consoleMode = "auto";
	};	
	initrd.luks.devices.crypted.device = "/dev/disk/by-partlabel/disk-secondary-encrypted-root";
    };

  services.spice-vdagentd.enable = true; 
  services.qemuGuest.enable = true;
    users.users = {
        osmo.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJY+rfJIZgXJXSso1p6P3eDUplsG51j1tZ5K8D0f5bpM osmo@osmo.zip"];
        #monitor.openssh.authorizedKeys.keys = ["ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGuCGoEj++ljHdu52zkWdZcizDCm+ljQEeuS5JSKhpDzqU3nOSLyNUKHkqJhoy9oUips+Lq4BV98PYDex8yiEFuIQFr9ZNq+0bdXPrwfonHtaqskBNWVqHyo41dD6pRI91z9WKc6Gm80HRUVVOrdbam9cyt+/V9HJALobdVglHF82HkQg== osmo@serveri"];
    };

    #TODO: Find a better place for this
    # common/optional/ssh.nix ?
    services.openssh = {
    	enable = true;
    	settings.PasswordAuthentication = false;
    	settings.KbdInteractiveAuthentication = false;
    	settings.PermitRootLogin = "no";
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowPing = true;
}
