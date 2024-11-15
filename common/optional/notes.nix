{ config, pkgs, ... }:
{
  /*
    sops.secrets = {
    	"syncthing/${config.networking.hostName}/key" = {
    		path = "/home/osmo/.config/syncthing/key.pem";
    		owner = config.users.users.osmo.name;
    		group = "syncthing";
    		mode = "0440";
    	};
    	"syncthing/${config.networking.hostName}/cert" = {
    		path = "/home/osmo/.config/syncthing/cert.pem";
    		owner = config.users.users.osmo.name;
    		group = "syncthing";
    		mode = "0440";
    	};
      };
      services.syncthing = {
        enable = true;
        user = "osmo";
        dataDir = "/home/osmo/Documents";
        configDir = "/home/osmo/.config/syncthing";
        overrideDevices = true;
        overrideFolders = true;
        guiAddress = "192.168.11.178:8384";
        settings = {
          devices = {
            "serveri" = { id = builtins.readFile ../../.secrets/syncthing/serveri-id; };
          };
          folders = {
            "koulu" = {         # Name of folder in Syncthing, also the folder ID
              path = "/home/osmo/Documents/koulu";    # Which folder to add to Syncthing
            #  devices = [ "serveri" ];      # Which devices to share the folder with
            };
          };
          gui = {
            user = "osmo";
    	password = "osmo";
    	#password = (builtins.readFile ../../.secrets/syncthing-password);
          };
        };
      };
        #networking.firewall.allowedTCPPorts = [ 8384 ];
  */
  users.users.osmo.packages = with pkgs; [ syncthingtray ];
}
