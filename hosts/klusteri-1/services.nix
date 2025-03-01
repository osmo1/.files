{
  imports = [
    ../../modules/containers
  ];

  services.containers = {
    jellyarr = {
      enable = true;
      dataLocation = "/home/osmo/jellyarr";
      uiPortStart = 1080;
      timeZone = "Europe/Helsinki";
      enableHomePage = true;
      enableTraefik = true;
      version = {
        qbittorrent = "5.0.3-r0-ls370";
        prowlarr = "1.28.2.4885-ls97";
        flaresolverr = "nodriver";
        sonarr = "4.0.11.2680-ls263";
        radarr = "5.16.3.9541-ls251";
        lidarr = "2.8.2.4493-ls22";
        readarr = "develop-0.4.6.2711-ls134";
        bazarr = "v1.5.0-ls284";
        jellyfin = "10.10.3";
        jellyseerr = "v2.1.0";
        bitmagnet = "v0.9.5";
        postgres = "16";
        gluetun = "v3.40.0";
        autobrr = "v1.56.1";
        cross-seed = "6.6.0";
      };
      options = {
        urlBase = "klusteri-1.kotiserweri.zip";
        mediaLocation = "/mnt/media";
      };
    };
    dockerproxy.enable = true;
    traefik = {
      enable = true;
      enableTraefik = true;
      version = "v3.1";
      uiPort = 280;
      dataLocation = "/home/osmo/traefik";
      options = {
        url = "klusteri-1.kotiserweri.zip";
      };
    };
  };
}
