{ config, ... }: {
    imports = [
        ../../modules/containers
	#../../modules/containers/test.nix
    ]/* ++ (if config.virtualisation.oci-containers.containers.deluge != null then [ ../../common/optional/vpn.nix ] else [])*/;

  services.containers = {
    dockerproxy.enable = true;
    pihole = {
	enable = true;
	version = "development";
	uiPort = 380;
	dataLocation = "/home/osmo/pihole";
	enableTraefik = true;
	enableHomePage = true;
    };
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
    luanti = {
        enable = true;
        version = "latest";
        dataLocation = "/home/osmo/luanti";
        timeZone = "Europe/Helsinki";
        options = {
            singlePort = "30000";
        };
    };
  };
}
