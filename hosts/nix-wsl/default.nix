{ config, lib, configLib, pkgs, nixvim, inputs, nur, ... }:
let
  hostnames = [ "testeri" "serveri" "klusteri-0" "klusteri-1" ]; # Add your hostnames here
in
{
    imports = (configLib.scanPaths ./.)
    ++ [
    	../../common/core
	#../../common/optional/cybersecurity.nix
    ];

    sops.secrets = builtins.listToAttrs (map (hostname: {
          name = "nixos/${hostname}/ssh/private";
          value = { 
	    path = "/home/osmo/.ssh/${hostname}";
	    owner = "osmo";
	    group = "users";
	    mode = "600";
	  };
    }) hostnames);
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
