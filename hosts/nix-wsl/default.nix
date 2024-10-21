{ config, lib, configLib, pkgs, nixvim, inputs, nur, ... }:

{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
	#../../common/optional/cybersecurity.nix
    ];

    system.stateVersion = "24.05";

    networking.hostName = "nix-wsl";
      wsl.enable = true;
  wsl.defaultUser = "osmo";

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
