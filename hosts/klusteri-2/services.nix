{
  imports = [
    ../../modules/containers
  ];

  services.containers = {
    dockerproxy.enable = true;
    copyparty = {
      enable = true;
      version = "1.19.21";
      ports.ui = 280;
      volumes = {
        config = "/home/osmo/copyparty";
        data = "/home/osmo/extra/copyparty";
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
    silverbullet = {
      enable = true;
      version = "2.3.0";
      uiPort = 380;
      enableHomePage = true;
      traefik = {
        enable = false;
      };
      newt.enable = true;
    };
    matrix = {
      enable = true;
      version = {
        tuwunel = "v1.4.7";
        cinny = "v4.10.2";
      };
      ports = {
        ui = 480;
        tuwunel = 8443;
      };
      dataLocation = "/home/osmo/matrix";
      enableHomePage = false;
      traefik.enable = false;
      newt.enable = true;
    };
    newt = {
      enable = true;
      version = "1.6.0";
      dataLocation = "/home/osmo/newt";
    };
  };
}
