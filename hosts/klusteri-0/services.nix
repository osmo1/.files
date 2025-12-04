{
  imports = [
    ../../modules/containers
  ];

  services.containers = {
    dockerproxy.enable = true;
    pihole = {
      enable = true;
      version = "2025.11.1";
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
      version = "v1.7.0";
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
      version = "v3.6.2";
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
        fresh = "1.27.1";
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
      version = "0.17.0";
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
      version = "v2.15.0";
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
    vaultwarden = {
      enable = true;
      version = "1.34.3";
      ports.ui = 1280;
      volume = "/home/osmo/vaultwarden";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    convertx = {
      enable = true;
      version = "v0.16.0";
      ports.ui = 1380;
      volume = "/home/osmo/convertx";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    linkwarden = {
      enable = true;
      versions = {
        linkwarden = "v2.13.1";
        postgres = "16-alpine";
        meilisearch = "v1.12.8";
      };
      ports.ui = 1480;
      volume = "/home/osmo/linkwarden";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    rresume = {
      enable = true;
      versions = {
        rresume = "v4.5.5";
        postgres = "16-alpine";
        minio = "RELEASE.2025-09-07T16-13-09Z";
        chrome = "v2.18.0";
      };
      ports.ui = 1580;
      volume = "/home/osmo/rresume";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    penpot = {
      enable = true;
      versions = {
        penpot = "2.11.1";
        postgres = "15";
        valkey = "8.1";
        mailcatch = "v0.9.0";
      };
      ports = {
        penpot = 1680;
        mailcatch = 1780;
      };
      volume = "/home/osmo/penpot";
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
    bento = {
      enable = true;
      version = "1.10.1";
      ports.ui = 1980;
      enableHomePage = true;
      traefik = {
        enable = true;
        urlBase = "klusteri-0.serweri.zip";
      };
    };
  };
}
