{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.wireguard;
in
{
  options.services.containers.wireguard = {
    enable = mkEnableOption "Enable wireguard with a web ui";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/wireguard";
    };
    uiPort = mkOption {
      type = types.port;
      default = 80;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
    };
    traefik = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      urlBase = mkOption {
        type = types.str;
        default = "klusteri-0.kotiserweri.zip";
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.wireguard = {
        hostname = "wireguard";
        image = "ghcr.io/wg-easy/wg-easy:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/etc/wireguard"
        ];
        ports = [
          "${toString cfg.uiPort}:51821"
          "51820:51820/udp"
        ];
        environment = {
          #TZ = "${cfg.timeZone}";
          WG_HOST = "80.222.53.107";
          WG_PERSISTENT_KEEPALIVE = "25";
          WG_DEFAULT_DNS = "192.168.11.10";
          UI_TRAFFIC_STATS = "true";
          WG_ALLOWED_IPS = "0.0.0.0/0, ::/0, 10.8.0.0/24, 10.8.0.0/32";
          WG_MTU = "1412";
        };
        extraOptions = [
          "--sysctl=net.ipv4.ip_forward=1"
          "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_MODULE"
          "--cap-add=NET_RAW"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Network";
                "homepage.name" = "Wireguad";
                "homepage.icon" = "wireguard";
                "homepage.href" = "https://wireguard.${cfg.traefik.urlBase}";
                "homepage.description" = "Local vpn service";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.wireguard.rule" = "Host(`wireguard.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.wireguard.entrypoints" = "websecure";
                "traefik.http.routers.wireguard.tls.certresolver" = "porkbun";
                "traefik.http.services.wireguard.loadbalancer.server.port" = "51821";
              }
            else
              { }
          );
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ cfg.uiPort ];
      allowedUDPPorts = [ 51820 ];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
    networking.nat = {
      enable = true;
      enableIPv6 = true;
    };
  };
}
