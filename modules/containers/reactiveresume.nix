{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.rresume;
in
{
  options.services.containers.rresume = {
    # The postgres database requires some prep though I'm not sure how much
    # What should work is: 1. Run it once without the user option and a 777 database mount dir
    # 2. Add the user option back and make sure the database dir is still 777 (it should re-perm it after the container is run)
    enable = mkEnableOption "Enable rresume resume builder";
    versions = {
      rresume = mkOption {
        type = types.str;
        default = "latest";
      };
      postgres = mkOption {
        type = types.str;
        default = "16-alpine";
      };
      minio = mkOption {
        type = types.str;
        default = "latest";
      };
      chrome = mkOption {
        type = types.str;
        default = "v2.18.0";
      };
    };
    ports = {
      ui = mkOption {
        type = types.port;
        default = 80;
      };
    };
    volume = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/rresume";
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
    options = {
      # For container specific options
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      "rresume" = {
        image = "amruthpillai/reactive-resume:${cfg.versions.rresume}";
        # Need rootless
        # user = "1000:100";

        ports = [
          "${toString cfg.ports.ui}:3000/tcp"
        ];
        volumes = [
          "${cfg.volume}/data:/data/data"
        ];
        environment = {
          DISABLE_SIGNUPS = "true"; # Create your user first

          PORT = "3000";
          NODE_ENV = "production";

          PUBLIC_URL = "http://resume.${cfg.traefik.urlBase}";
          STORAGE_URL = "https://minio-rresume.${cfg.traefik.urlBase}/default";

          CHROME_URL = "ws://chrome-rresume:3000";

          MAIL_FROM = "noreply@localhost";

          STORAGE_ENDPOINT = "minio-rresume";
          STORAGE_PORT = "9000";
          STORAGE_BUCKET = "default";
          STORAGE_USE_SSL = "false";
          STORAGE_SKIP_BUCKET_CHECK = "false";
        };
        environmentFiles = [ "${config.sops.secrets.rresume.path}" ];

        dependsOn = [
          "postgres-rresume"
          "minio-rresume"
          "chrome-rresume"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Services";
                "homepage.name" = "Reactive Resume";
                "homepage.icon" = "reactive-resume";
                "homepage.href" = "https://resume.${cfg.traefik.urlBase}";
                "homepage.description" = "Resume builder";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.rresume.rule" = "Host(`resume.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.rresume.entrypoints" = "websecure";
                "traefik.http.routers.rresume.tls.certresolver" = "porkbun";
                "traefik.http.services.rresume.loadbalancer.server.port" = "3000";
              }
            else
              { }
          );
      };
      "postgres-rresume" = {
        image = "postgres:${cfg.versions.postgres}";
        # Need rootless
        user = "1000:100";

        volumes = [
          "${cfg.volume}/postgres:/var/lib/postgresql/data"
          "/etc/passwd:/etc/passwd:ro"
        ];
        environment = {
          testFlag = "test";
        };
        environmentFiles = [ "${config.sops.secrets.postgres-rresume.path}" ];
      };
      "minio-rresume" = {
        image = "minio/minio:${cfg.versions.minio}";
        # Need rootless
        # user = "1000:100";

        volumes = [
          "${cfg.volume}/minio:/data"
        ];
        environmentFiles = [ "${config.sops.secrets.minio-rresume.path}" ];

        cmd = [
          "server"
          "/data"
        ];
        labels = (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.minio-rresume.rule" = "Host(`minio-rresume.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.minio-rresume.entrypoints" = "websecure";
              "traefik.http.routers.minio-rresume.tls.certresolver" = "porkbun";
              "traefik.http.services.minio-rresume.loadbalancer.server.port" = "9000";
            }
          else
            { }
        );
      };
      "chrome-rresume" = {
        image = "ghcr.io/browserless/chromium:${cfg.versions.chrome}";
        # Need rootless
        # user = "1000:100";

        environment = {
          TIMEOUT = "10000";
          CONCURRENT = "10";
          EXIT_ON_HEALTH_FAILURE = "true";
          PRE_REQUEST_HEALTH_CHECK = "true";
        };
        environmentFiles = [ "${config.sops.secrets.chrome-rresume.path}" ];

        extraOptions = [
          "--add-host=host.docker.internal:host-gateway"
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.volume} 0770 osmo users - -"
      "d ${cfg.volume}/data 0770 osmo users - -"
      "d ${cfg.volume}/postgres 0770 osmo users - -"
      "d ${cfg.volume}/minio 0770 osmo users - -"
    ];

    # Secrets
    sops.secrets = {
      rresume = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-rresume.service" ];
        owner = "osmo";
        group = "users";
      };
      postgres-rresume = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-postgres-rresume.service" ];
        owner = "osmo";
        group = "users";
      };
      minio-rresume = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-minio-rresume.service" ];
        owner = "osmo";
        group = "users";
      };
      chrome-rresume = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-chrome-rresume.service" ];
        owner = "osmo";
        group = "users";
      };
    };
  };
}
