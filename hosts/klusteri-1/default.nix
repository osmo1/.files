{ config, lib, configLib, pkgs, nixvim, inputs, nur, ... }:

{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
	      ../../common/optional/cli
#../../common/optional/impermanence.nix
	      ../../common/optional/podman.nix
#../../common/optional/vpn.nix
	      ../../common/optional/tpm.nix
	      ../../common/optional/ssh.nix
	      ../../common/optional/nfs-mount.nix
          ../../common/optional/systemd-boot.nix
	      #../../common/optional/xfce
	      #../../common/optional/sddm.nix
	      #../../common/optional/proton.nix
	      #../../common/optional/sddm.nix
	#../../common/optional/dwl
      #../../common/optional/samba.nix
    ];

    system.stateVersion = "24.05";

    networking.hostName = "klusteri-1";

    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowPing = true;
}
