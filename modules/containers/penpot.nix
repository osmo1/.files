{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.penpot;
in
{
  options.services.containers.penpot = {
    # The postgres database requires some prep though I'm not sure how much
    # What should work is: 1. Run it once without the user option and a 777 database mount dir
    # 2. Add the user option back and make sure the database dir is still 777 (it should re-perm it after the container is run)
    enable = mkEnableOption "Enable penpot website designer";
    versions = {
      penpot = mkOption {
        type = types.str;
        default = "latest";
      };
      postgres = mkOption {
        type = types.str;
        default = "15";
      };
      valkey = mkOption {
        type = types.str;
        default = "8.1";
      };
      mailcatch = mkOption {
        type = types.str;
        default = "latest";
      };
    };
    ports = {
      penpot = mkOption {
        type = types.port;
        default = 80;
      };
      mailcatch = mkOption {
        type = types.port;
        default = 180;
      };
    };
    volume = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/penpot";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
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
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
    };
    newt = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      "penpot-frontend" = {
        image = "penpotapp/frontend:${cfg.versions.penpot}";
        # Need rootless
        # user = "1000:100";

        ports = [
          "${toString cfg.ports.penpot}:8080/tcp"
        ];
        volumes = [
          "${cfg.volume}/assets:/opt/data/assets"
        ];
        environment = {
          "PENPOT_FLAGS" =
            "disable-email-verification enable-smtp enable-prepl-server disable-secure-session-cookies";
          "PENPOT_HTTP_SERVER_MAX_BODY_SIZE" = "31457280";
          "PENPOT_HTTP_SERVER_MAX_MULTIPART_BODY_SIZE" = "367001600";

          "PENPOT_PUBLIC_URI" = "http://penpot.${cfg.traefik.urlBase}";
        };

        dependsOn = [
          "penpot-backend"
          "penpot-exporter"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Services";
                "homepage.name" = "Penpot";
                "homepage.icon" = "penpot";
                "homepage.href" = "https://penpot.${cfg.traefik.urlBase}";
                "homepage.description" = "Website designer";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.penpot.rule" = "Host(`penpot.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.penpot.entrypoints" = "websecure";
                "traefik.http.routers.penpot.tls.certresolver" = "porkbun";
                "traefik.http.services.penpot.loadbalancer.server.port" = "8080";
              }
            else
              { }
          );
      };
      "penpot-backend" = {
        image = "penpotapp/backend:${cfg.versions.penpot}";
        # Need rootless
        # user = "1000:100";

        volumes = [
          "${cfg.volume}/assets:/opt/data/assets"
        ];
        environment = {
          "PENPOT_FLAGS" =
            "disable-email-verification enable-smtp enable-prepl-server disable-secure-session-cookies";
          "PENPOT_HTTP_SERVER_MAX_BODY_SIZE" = "31457280";
          "PENPOT_HTTP_SERVER_MAX_MULTIPART_BODY_SIZE" = "367001600";

          "PENPOT_PUBLIC_URI" = "http://penpot.${cfg.traefik.urlBase}";

          PENPOT_DATABASE_URI = "postgresql://postgres-penpot/penpot";
          PENPOT_ASSETS_STORAGE_BACKEND = "assets-fs";
          PENPOT_STORAGE_ASSETS_FS_DIRECTORY = "/opt/data/assets";

          PENPOT_TELEMETRY_ENABLED = "false";
          PENPOT_TELEMETRY_REFERER = "compose";

          PENPOT_REDIS_URI = "redis://valkey-penpot/0";
        };
        environmentFiles = [ "${config.sops.secrets.penpot.path}" ];

        dependsOn = [
          "postgres-penpot"
          "valkey-penpot"
        ];
      };
      "penpot-exporter" = {
        image = "penpotapp/exporter:${cfg.versions.penpot}";
        # Need rootless
        # user = "1000:100";

        environment = {
          PENPOT_PUBLIC_URI = "http://penpot-frontend:8080";
          PENPOT_REDIS_URI = "redis://valkey-penpot/0";
        };

        dependsOn = [
          "valkey-penpot"
        ];
      };
      "postgres-penpot" = {
        image = "postgres:${cfg.versions.postgres}";
        # Need rootless
        user = "1000:100";

        volumes = [
          "${cfg.volume}/postgres:/var/lib/postgresql/data"
          "/etc/passwd:/etc/passwd:ro"
        ];
        environment = {
          POSTGRES_INITDB_ARGS = "--data-checksums";
        };
        environmentFiles = [ "${config.sops.secrets.postgres-penpot.path}" ];
      };
      "valkey-penpot" = {
        image = "valkey/valkey:${cfg.versions.valkey}";
        # Need rootless
        # user = "1000:100";

        environment = {
          VALKEY_EXTRA_FLAGS = "--maxmemory 128mb --maxmemory-policy volatile-lfu";
        };
      };
      "mailcatch-penpot" = {
        image = "sj26/mailcatcher:${cfg.versions.mailcatch}";
        # Need rootless
        # user = "1000:100";

        ports = [
          "${toString cfg.ports.mailcatch}:1080/tcp"
        ];

        labels = (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.penpot-mailcatch.rule" = "Host(`penpot-mailcatch.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.penpot-mailcatch.entrypoints" = "websecure";
              "traefik.http.routers.penpot-mailcatch.tls.certresolver" = "porkbun";
              "traefik.http.services.penpot-mailcatch.loadbalancer.server.port" = "1080";
            }
          else
            { }
        );
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.volume} 0770 osmo users - -"
      "d ${cfg.volume}/assets 0770 osmo users - -"
      "d ${cfg.volume}/postgres 0770 osmo users - -"
    ];

    # Secrets
    sops.secrets = {
      penpot = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [
          "podman-penpot-backend.service"
          "podman-penpot-exporter.service"
        ];
        owner = "osmo";
        group = "users";
      };
      postgres-penpot = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-postgres-penpot.service" ];
        owner = "osmo";
        group = "users";
      };
    };
  };
}
