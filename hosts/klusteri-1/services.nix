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
        qbittorrent = "5.1.4";
        prowlarr = "2.3.0";
        flaresolverr = "nodriver"; # There was some problem with this and its nodriver for some (?) reason
        sonarr = "4.0.16";
        radarr = "6.0.4";
        lidarr = "3.1.0";
        bazarr = "1.5.3";
        jellyfin = "10.11.4";
        jellyseerr = "2.7.3";
        bitmagnet = "v0.10.0";
        postgres = "16"; # I'll touch this again only when it breaks
        gluetun = "v3.40.3";
        autobrr = "v1.70.0";
        cross-seed = "6.13.6";
        booklore = "v1.13.1";
        profilarr = "v1.1.3";
        ephemera = "1.3.1";
      };
      options = {
        urlBase = "klusteri-1.serweri.zip";
        mediaLocation = "/mnt/media";
      };
    };
    dockerproxy.enable = true;
    traefik = {
      enable = true;
      enableTraefik = true;
      version = "v3.4.3";
      uiPort = 280;
      dataLocation = "/home/osmo/traefik";
      options = {
        url = "klusteri-1.serweri.zip";
      };
    };
  };
}
