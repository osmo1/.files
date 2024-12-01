{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.wireguard;
in {
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
    enableTraefik = mkOption {
      type = types.bool;
      default = true;
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
            WG_PERSISTENT_KEEPALIVE = "25";
        };
        extraOptions = [
          "--sysctl=net.ipv4.ip_forward=1"
          "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_MODULE"
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "Network";
          "homepage.name" = "Wireguad";
          "homepage.icon" = "wireguard";
          "homepage.href" = "https://wireguard.${cfg.options.urlBase}";
          "homepage.description" = "Local vpn service";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.stump.rule" = "Host(`wireguard.${cfg.options.urlBase}`)";
          "traefik.http.routers.stump.entrypoints" = "websecure";
          "traefik.http.routers.stump.tls.certresolver" = "porkbun";
          "traefik.http.services.stump.loadbalancer.server.port" = "51820";
        } else {} );
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ cfg.uiPort ];
      allowedUDPPorts = [ 51820 ];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}

