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
      enableHomePage = true;
      traefik = {
        enable = true;
        baseUrl = "klusteri-0.serweri.zip";
      };
    };
    homepage = {
      enable = true;
      version = "v1.3.2";
      uiPort = 180;
      dataLocation = "/home/osmo/homepage";
      traefik = {
        enable = true;
        baseUrl = "klusteri-0.serweri.zip";
      };
      options = {
      };
    };
    traefik = {
      enable = true;
      version = "v3.4.3";
      uiPort = 280;
      dataLocation = "/home/osmo/traefik";
      options = {
        url = "klusteri-0.serweri.zip";
      };
    };
    wireguard = {
      enable = true;
      version = "15.1.0";
      uiPort = 480;
      dataLocation = "/home/osmo/wireguard";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    rss = {
      enable = true;
      version = {
        fresh = "1.26.3";
        full-text = "3.8.1";
        dockerss = "0.6.1"; # Pretty much discontinued but still works
      };
      ports = {
        full-textUi = 580;
        freshUi = 680;
        dockerssUi = 780;
      };
      volumes = {
        fresh = "/home/osmo/fresh";
        full-text = "/home/osmo/ftrss";
      };
      enableHomePage = true;
      traefik = {
        enable = true;
        baseUrl = "klusteri-0.serweri.zip";
      };
    };
    home-assistant = {
      enable = false;
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
    anisette = {
      enable = true;
    };
    beszel = {
      enable = true;
      version = "0.16.1";
      ports.ui = 1080;
      volume = "/home/osmo/beszel";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    ntfy = {
      enable = true;
      version = "v2.14.0";
      ports.ui = 1180;
      volumes = {
        config = "/home/osmo/ntfy/server.yml";
        cache = "/home/osmo/ntfy/cache";
      };
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
  };
}
