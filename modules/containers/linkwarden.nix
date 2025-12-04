{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.linkwarden;
in
{
  options.services.containers.linkwarden = {
    # The postgres database requires some prep though I'm not sure how much
    # What should work is: 1. Run it once without the user option and a 777 database mount dir
    # 2. Add the user option back and make sure the database dir is still 777 (it should re-perm it after the container is run)
    enable = mkEnableOption "Enable linkwarden link manager";
    versions = {
      linkwarden = mkOption {
        type = types.str;
        default = "latest";
      };
      postgres = mkOption {
        type = types.str;
        default = "16-alpine";
      };
      meilisearch = mkOption {
        type = types.str;
        default = "v1.12.8";
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
      default = "${config.users.users.osmo.home}/linkwarden";
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
      "linkwarden" = {
        image = "ghcr.io/linkwarden/linkwarden:${cfg.versions.linkwarden}";
        # Need rootless
        # user = "1000:100";

        ports = [
          "${toString cfg.ports.ui}:3000/tcp"
        ];
        volumes = [
          "${cfg.volume}/data:/data/data"
        ];
        environment = {
          NEXTAUTH_URL = "http://localhost:3000/api/v1/auth";
          MEILI_HOST = "meilisearch-linkwarden:7700";
          NEXT_PUBLIC_DISABLE_REGISTRATION = "true"; # Create your user first
        };
        environmentFiles = [ "${config.sops.secrets.linkwarden.path}" ];

        dependsOn = [
          "postgres-linkwarden"
          "meilisearch-linkwarden"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Services";
                "homepage.name" = "Linkwarden";
                "homepage.icon" = "linkwarden";
                "homepage.href" = "https://link.${cfg.traefik.urlBase}";
                "homepage.description" = "Link manager";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.linkwarden.rule" = "Host(`link.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.linkwarden.entrypoints" = "websecure";
                "traefik.http.routers.linkwarden.tls.certresolver" = "porkbun";
                "traefik.http.services.linkwarden.loadbalancer.server.port" = "3000";
              }
            else
              { }
          );
      };
      "postgres-linkwarden" = {
        image = "postgres:${cfg.versions.postgres}";
        # Need rootless
        user = "1000:100";

        volumes = [
          "${cfg.volume}/postgres:/var/lib/postgresql/data"
          "/etc/passwd:/etc/passwd:ro"
        ];
        environmentFiles = [ "${config.sops.secrets.postgres-linkwarden.path}" ];
      };
      "meilisearch-linkwarden" = {
        image = "getmeili/meilisearch:${cfg.versions.meilisearch}";
        # Need rootless
        # user = "1000:100";

        volumes = [
          "${cfg.volume}/meilisearch:/meili_data"
        ];
        environmentFiles = [ "${config.sops.secrets.meilisearch-linkwarden.path}" ];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.volume} 0770 osmo users - -"
      "d ${cfg.volume}/data 0770 osmo users - -"
      "d ${cfg.volume}/postgres 0770 osmo users - -"
      "d ${cfg.volume}/meilisearch 0770 osmo users - -"
    ];

    # Secrets
    sops.secrets = {
      linkwarden = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-linkwarden.service" ];
        owner = "osmo";
        group = "users";
      };
      postgres-linkwarden = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-postgres-linkwarden.service" ];
        owner = "osmo";
        group = "users";
      };
      meilisearch-linkwarden = {
        sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
        restartUnits = [ "podman-meilisearch-linkwarden.service" ];
        owner = "osmo";
        group = "users";
      };
    };
  };
}
