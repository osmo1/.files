{
  imports = [
    ../../modules/containers
  ];

  services.containers = {
    dockerproxy.enable = true;
    pihole = {
      enable = true;
      version = "2025.06.2";
      uiPort = 380;
      dataLocation = "/home/osmo/pihole";
      enableTraefik = true;
      enableHomePage = true;
    };
    homepage = {
      enable = true;
      enableTraefik = true;
      version = "v1.3.2";
      uiPort = 180;
      dataLocation = "/home/osmo/homepage";
      options = {
        url = "home.klusteri-0.kotiserweri.zip";
      };
    };
    traefik = {
      enable = true;
      version = "v3.4.3";
      uiPort = 280;
      dataLocation = "/home/osmo/traefik";
      options = {
        url = "klusteri-0.kotiserweri.zip";
      };
    };
    wireguard = {
      enable = true;
      version = "15.0.0";
      uiPort = 480;
      dataLocation = "/home/osmo/wireguard";
      enableHomePage = true;
      traefik = {
        enable = true;
      };
    };
    rss = {
      enable = true;
      version = "1.26.3";
      morssUiPort = 580;
      freshUiPort = 680;
      dockerssUiPort = 780;
      dataLocation = "/home/osmo/fresh";
      enableHomePage = true;
      traefik = {
        enable = true;
      };
    };
    home-assistant = {
      enable = true;
      uiPort = 980;
      dataLocation = "/home/osmo/sontainers/home-assistant";
      enableHomePage = true;
      traefik = {
        enable = true;
      };
      options = {
        enableBind = true;
        bindDataLocation = "/home/osmo/home-assistant";
      };
    };
  };
}
