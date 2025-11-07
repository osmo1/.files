{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.ntfy;
in
{
  options.services.containers.ntfy = {
    enable = mkEnableOption "Enable ntfy notifications";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    ports = {
      ui = mkOption {
        type = types.port;
        default = 80;
      };
    };
    volumes = {
      config = mkOption {
        type = types.str;
        default = "${config.users.users.osmo.home}/ntfy/server.yml";
      };
      cache = mkOption {
        type = types.str;
        default = "${config.users.users.osmo.home}/ntfy/cache";
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
      urlBase = mkOption {
        type = types.str;
        default = "klusteri-0.serweri.zip";
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."ntfy" = {
      image = "binwiederhier/ntfy:${cfg.version}";
      environment = {
      };
      volumes = [
        "${cfg.volumes.cache}:/var/cache/ntfy"
        "${cfg.volumes.config}:/etc/ntfy/server.yml"
      ];
      ports = [
        "${toString cfg.ports.ui}:8080/tcp"
      ];
      cmd = [
        "serve"
        "--cache-file"
        "/var/cache/ntfy/cache.db"
        "--listen-http"
        ":8080"
      ];
      user = "1000:100";
      labels =
        (
          if cfg.enableHomePage == true then
            {
              "homepage.group" = "Services";
              "homepage.name" = "ntfy";
              "homepage.icon" = "ntfy";
              "homepage.href" = "https://ntfy.${cfg.traefik.urlBase}";
              "homepage.description" = "Ntfy notification server";
            }
          else
            { }
        )
        // (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.ntfy.rule" = "Host(`ntfy.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.ntfy.entrypoints" = "websecure";
              "traefik.http.routers.ntfy.tls.certresolver" = "porkbun";
              "traefik.http.services.ntfy.loadbalancer.server.port" = "8080";
            }
          else
            { }
        );
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.volumes.cache} 0770 osmo users - -"
      "f ${cfg.volumes.config} 0770 osmo users - -"
    ];
  };
}
