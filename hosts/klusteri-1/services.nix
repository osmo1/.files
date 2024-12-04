{
  imports = [
    ../../modules/containers
    #../../modules/containers/test.nix
  ];

  services.containers = {
    jellyarr = {
      enable = true;
      dataLocation = "/home/osmo/jellyarr";
      uiPortStart = 1080;
      timeZone = "Europe/Helsinki";
      enableHomePage = true;
      enableTraefik = true;
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
        url = "traefik.klusteri-1.kotiserweri.zip";
      };
    };
  };
}
