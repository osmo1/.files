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
      enableHomePage = true;
      options = {
	urlBase = "klusteri-0.kotiserweri.zip";
      };
    };
    pihole = {
	enable = true;
	version = "development";
	uiPort = 380;
	dataLocation = "/home/osmo/pihole";
	enableTraefik = true;
	enableHomePage = true;
    };
    dockerproxy.enable = true;
    homepage = {
        enable = true;
        enableTraefik = true;
        version = "latest";
        uiPort = 180;
        dataLocation = "/home/osmo/homepage";
        options = {
            url = "home.klusteri-0.kotiserweri.zip";
        };
    };
    traefik = {
	enable = true;
	version = "v3.1";
	uiPort = 280;
	dataLocation = "/home/osmo/traefik";
    options = {
        url = "traefik.klusteri-0.kotiserweri.zip";
    };
    };
  };


    #services.docker.crafty = {
    #    enable = true;
    #    version = "latest";
    #    volumesBase = "/home/osmo/crafty";
    #    webUIPort = 380;
    #};
}
