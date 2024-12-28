{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.rss;
in
{
  options.services.containers.rss = {
    enable = mkEnableOption "Enable full text rss and rss sync services";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    uiPort = mkOption {
      type = types.port;
      default = 80;
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/fresh";
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
    options =
      {
      };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.morss = {
        hostname = "morss";
        image = "pictuga/morss:${cfg.version}";
        volumes = [
        ];
        ports = [
          "${toString cfg.uiPort}:8000"
        ];
        environment = {
        };
        extraOptions = [
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "RSS";
                "homepage.name" = "Morss";
                "homepage.icon" = "morss";
                "homepage.href" = "https://morss.${cfg.traefik.urlBase}";
                "homepage.description" = "Full text rss generator";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.morss.rule" = "Host(`morss.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.morss.entrypoints" = "websecure";
                "traefik.http.routers.morss.tls.certresolver" = "porkbun";
                "traefik.http.services.morss.loadbalancer.server.port" = "8000";
              }
            else
              { }
          );
      };
      containers.fresh = {
        hostname = "fresh";
        image = "lscr.io/linuxserver/freshrss:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/config"
        ];
        ports = [
          "${toString cfg.uiPort}:80"
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
                "homepage.href" = "https://fresh.${cfg.traefik.urlBase}";
                "homepage.description" = "RSS feed aggregator";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.fresh.rule" = "Host(`fresh.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.fresh.entrypoints" = "websecure";
                "traefik.http.routers.fresh.tls.certresolver" = "porkbun";
                "traefik.http.services.fresh.loadbalancer.server.port" = "80";
              }
            else
              { }
          );
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ cfg.uiPort ];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
