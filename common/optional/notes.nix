{ config, ... }: {
  services.syncthing = {
    enable = true;
    user = "osmo";
    dataDir = "/home/osmo/Documents";
    configDir = "/home/osmo/.config/syncthing";
    key = (builtins.readFile config.sops.secrets."syncthing/${config.networking.hostName}/key".path);
    cert = (builtins.readFile config.sops.secrets."syncthing/${config.networking.hostName}/cert".path);
    overrideDevices = true;
    overrideFolders = true;
    guiAddress = "127.0.0.1:8384";
    settings = {
      devices = {
        "serveri" = { id = (builtins.readFile config.sops.secrets."syncthing/serveri/id".path); };
      };
      folders = {
        "koulu" = {         # Name of folder in Syncthing, also the folder ID
          path = "/home/osmo/Documents/koulu";    # Which folder to add to Syncthing
          devices = [ "serveri" ];      # Which devices to share the folder with
        };
      };
      gui = {
        user = "osmo";
	password = (builtins.readFile config.sops.secrets."syncthing/gui/password".path);
      };
    };
  };
    networking.firewall.allowedTCPPorts = [ 8384 ];
}
