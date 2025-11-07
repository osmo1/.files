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
        qbittorrent = "5.1.2-r1-ls406";
        prowlarr = "1.37.0.5076-ls123";
        flaresolverr = "nodriver"; # There was some problem with this and its nodriver for some (?) reason
        sonarr = "4.0.15.2941-ls288";
        radarr = "5.26.2.10099-ls279";
        lidarr = "2.12.4.4658-ls48";
        readarr = "nightly-0.4.19.2811-ls400"; # It got discontinued, I'm still deciding if I should even keep this
        bazarr = "v1.5.2-ls311";
        jellyfin = "10.10.7";
        jellyseerr = "v2.7.2";
        bitmagnet = "v0.10.0";
        postgres = "16"; # I'll touch this again only when it breaks
        gluetun = "v3.40.0";
        autobrr = "v1.64.0";
        cross-seed = "v6.13.1";
        stump = "nightly";
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
