{
    imports = [
        ../../modules/containers
	#../../modules/containers/test.nix
    ];

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
      enable = true;
      dataLocation = "/home/osmo/jellyarr";
      uiPortStart = 1080;
      timeZone = "Europe/Helsinki";
      enableHomePage = true;
      enableTraefik = true;
      options = {
	urlBase = "klusteri-1.kotiserweri.zip";
	mediaLocation = "/mnt/media";
      };
    };
    dockerproxy.enable = true;
    traefik = {
	enable = true;
	version = "v3.1";
	uiPort = 280;
	dataLocation = "/home/osmo/traefik";
    options = {
        url = "traefik.klusteri-1.kotiserweri.zip";
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
