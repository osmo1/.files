{ config, ... }: {
    imports = [
        ../../modules/containers
	#../../modules/containers/test.nix
    ]/* ++ (if config.virtualisation.oci-containers.containers.deluge != null then [ ../../common/optional/vpn.nix ] else [])*/;

  services.containers = {
    crafty = {
      enable = false;
      dataLocation = "/home/osmo/crafty";
      uiPort = 38000;
      timeZone = "Europe/Helsinki";
      enableHomePage = false;
      options = {
        portOffset = 0;
        enableRcon = false;
      };
    };
    jellyarr = {
      enable = false;
      dataLocation = "/home/osmo/jellyarr";
      uiPortStart = 1080;
      timeZone = "Europe/Helsinki";
      enableHomePage = false;
      options = {
	urlBase = "osmo1.duckdns.org";
      };
    };
    pihole = {
      enable = true;
      dataLocation = "/home/osmo/pihole";
      version = "development";
      uiPort = 480;
      timeZone = "Europe/Helsinki";
      enableHomePage = true;
    };
    dockerproxy.enable = true;
    homepage = {
	enable = true;
	version = "latest";
	uiPort = 180;
	dataLocation = "/home/osmo/homepage";
    };
  };


    #services.docker.crafty = {
    #    enable = true;
    #    version = "latest";
    #    volumesBase = "/home/osmo/crafty";
    #    webUIPort = 380;
    #};
}
