{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.rss;
in
{
  options.services.containers.rss = {
    enable = mkEnableOption "Enable full text rss and rss sync services";
    version = {
      fresh = mkOption {
        type = types.str;
        default = "latest";
      };
      full-text = mkOption {
        type = types.str;
        default = "latest";
      };
      dockerss = mkOption {
        type = types.str;
        default = "latest";
      };
    };
    ports = {
      full-textUi = mkOption {
        type = types.port;
        default = 80;
      };
      freshUi = mkOption {
        type = types.port;
        default = 180;
      };
      dockerssUi = mkOption {
        type = types.port;
        default = 280;
      };
    };
    volumes = {
      fresh = mkOption {
        type = types.str;
        default = "${config.users.users.osmo.home}/fresh";
      };
      full-text = mkOption {
        type = types.str;
        default = "${config.users.users.osmo.home}/ftrss";
      };
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
      baseUrl = mkOption {
        type = types.str;
        default = "klusteri-0.serweri.zip";
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      full-text = {
        hostname = "full-text";
        image = "heussd/fivefilters-full-text-rss:${cfg.version.full-text}";
        volumes = [
          "${cfg.volumes.full-text}:/var/www/html/cache/rss"
        ];
        ports = [
          "${toString cfg.ports.full-textUi}:80"
        ];
        environment = {
          FTR_ADMIN_PASSWORD = "test";
        };
        extraOptions = [
        ];
        # user = "1000:100";
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "RSS";
                "homepage.name" = "Full text rss";
                "homepage.icon" = "full-text-rss";
                "homepage.href" = "https://ftrss.${cfg.traefik.baseUrl}";
                "homepage.description" = "Full text rss generator";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.full-text.rule" = "Host(`ftrss.${cfg.traefik.baseUrl}`)";
                "traefik.http.routers.full-text.entrypoints" = "websecure";
                "traefik.http.routers.full-text.tls.certresolver" = "porkbun";
                "traefik.http.services.full-text.loadbalancer.server.port" = "80";
              }
            else
              { }
          );
      };
      fresh = {
        hostname = "fresh";
        image = "lscr.io/linuxserver/freshrss:${cfg.version.fresh}";
        volumes = [
          "${cfg.volumes.fresh}:/config"
        ];
        ports = [
          "${toString cfg.ports.freshUi}:80"
        ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "RSS";
                "homepage.name" = "Fresh rss";
                "homepage.icon" = "freshrss";
                "homepage.href" = "https://fresh.${cfg.traefik.baseUrl}";
                "homepage.description" = "RSS feed aggregator";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.fresh.rule" = "Host(`fresh.${cfg.traefik.baseUrl}`)";
                "traefik.http.routers.fresh.entrypoints" = "websecure";
                "traefik.http.routers.fresh.tls.certresolver" = "porkbun";
                "traefik.http.services.fresh.loadbalancer.server.port" = "80";
              }
            else
              { }
          );
      };
      dockerss = {
        hostname = "dockerss";
        image = "theconnman/docker-hub-rss:${cfg.version.dockerss}";

        ports = [
          "${toString cfg.ports.dockerssUi}:3000"
        ];

        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "RSS";
                "homepage.name" = "dockerss";
                "homepage.icon" = "dockerss";
                "homepage.href" = "https://dockerss.${cfg.traefik.baseUrl}";
                "homepage.description" = "RSS feed aggregator";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.dockerss.rule" = "Host(`dockerss.${cfg.traefik.baseUrl}`)";
                "traefik.http.routers.dockerss.entrypoints" = "websecure";
                "traefik.http.routers.dockerss.tls.certresolver" = "porkbun";
                "traefik.http.services.dockerss.loadbalancer.server.port" = "3000";
              }
            else
              { }
          );
      };
    };
    networking.firewall.allowedTCPPorts = builtins.attrValues cfg.ports;
    systemd.tmpfiles.rules = [
      "d ${cfg.volumes.fresh} 0770 osmo users - -"
      "d ${cfg.volumes.full-text} 0770 osmo users - -"
    ];
  };
}
