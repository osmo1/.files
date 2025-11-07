{
  imports = [
    ../../modules/containers
  ];
  services.containers = {
    nextcloud = {
      enable = true;
      version = "30";
      uiPort = 180;
      dataLocation = "/home/osmo/data/nextcloud";
      configLocation = "/home/osmo/nextcloud";
      traefik.enable = true;
    };
    dockerproxy.enable = true;
    traefik = {
      enable = true;
      version = "v3.1";
      uiPort = 280;
      dataLocation = "/home/osmo/traefik";
      options = {
        url = "serveri.serweri.zip";
      };
    };
  };
}
