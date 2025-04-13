{
  imports = [
    ../../modules/containers
  ];

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
      version = "v0.10.9";
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
        url = "klusteri-0.kotiserweri.zip";
      };
    };
    wireguard = {
      enable = true;
      version = "latest";
      uiPort = 480;
      dataLocation = "/home/osmo/wireguard";
      enableHomePage = true;
      traefik = {
        enable = true;
      };
    };
    rss = {
      enable = true;
      version = "latest";
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
      version = "latest";
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
