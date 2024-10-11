{ config, lib, configLib, pkgs, pkgs-unstable, nixvim, inputs, nur, ... }:

{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
	../../common/optional/disks/1-luks-btrfs.nix
	      ../../common/optional/impermanence.nix
	      #../../common/optional/podman.nix
	      #../../common/optional/vpn.nix
	      #../../common/optional/xfce
	      #../../common/optional/sddm.nix
	      #../../common/optional/proton.nix
	      #../../common/optional/sddm.nix
	#../../common/optional/dwl
      #../../common/optional/samba.nix
    ];

    system.stateVersion = "24.05";

    networking.hostName = "klusteri-1";

    #TODO: Find a better place for this
    # common/core ?
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
	systemd-boot.enable = true;
	systemd-boot.consoleMode = "auto";
	};	
	initrd.luks.devices.crypted.device = lib.mkForce "/dev/disk/by-partlabel/disk-main-crypted";
    };
  



  services.spice-vdagentd.enable = true; 
  services.qemuGuest.enable = true;

    #TODO: Find a better place for this
    # common/optional/ssh.nix ?
    services.openssh = {
    	enable = true;
        ports = [ 22 ];
    	settings.PasswordAuthentication = false;
    	settings.KbdInteractiveAuthentication = false;
    	settings.PermitRootLogin = "no";
    };

    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowPing = true;
}
