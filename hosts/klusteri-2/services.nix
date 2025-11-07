{
  imports = [
    ../../modules/containers
  ];

  services.containers = {
    dockerproxy.enable = true;
    copyparty = {
      enable = true;
      version = "1.18.9";
      ports.ui = 80;
      volumes = {
        config = "/home/osmo/copyparty";
        data = "/home/osmo/media";
      };
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-2.serweri.zip";
      };
    };
    traefik = {
      enable = true;
      version = "v3.4.3";
      uiPort = 180;
      dataLocation = "/home/osmo/traefik";
      options = {
        url = "klusteri-2.serweri.zip";
      };
    };
  };
}
