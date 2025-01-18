{ config, ... }:
{
  imports = [
    ../../modules/containers
    #../../modules/containers/test.nix
  ] # ++ (if config.virtualisation.oci-containers.containers.deluge != null then [ ../../common/optional/vpn.nix ] else [])
  ;

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
      version = "latest";
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
        url = "traefik.klusteri-0.kotiserweri.zip";
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
    ente = {
      enable = false;
      uiPort = 880;
      dataLocation = "/home/osmo/ente";
      enableHomePage = true;
      version = {
          museum = "8656f698c0c66cf1573c2c000b81d2d93c73c69c";
          postgres = "16";
          minio = "RELEASE.2024-12-18T13-15-44Z";
          mc = "RELEASE.2024-11-21T17-21-54Z";
          socat = "1.8.0.0";
      };
      traefik = {
        enable = true;
      };
    };
    home-assistant = {
      enable = true;
      version = "latest";
      uiPort = 980;
      dataLocation = "/home/osmo/home-assistant";
      enableHomePage = true;
      traefik = {
        enable = true;
      };
    };
  };
}
