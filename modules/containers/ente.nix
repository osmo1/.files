{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.services.containers.ente;
in
{
  options.services.containers.ente = {
    enable = mkEnableOption "Enable full text ente and ente sync services";
    uiPort = mkOption {
      type = types.port;
      default = 80;
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/ente";
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
    version = {
        museum = mkOption {
          type = types.str;
          default = "latest";
        };
        postgres = mkOption {
          type = types.str;
          default = "latest";
        };
        minio = mkOption {
          type = types.str;
          default = "latest";
        };
        mc = mkOption {
          type = types.str;
          default = "latest";
        };
        socat = mkOption {
          type = types.str;
          default = "latest";
        };
    };
    options =
      {
      mediaLocation = mkOption {
        type = types.str;
        default = "/mnt/media";
      };
      };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.ente = {
        hostname = "ente";
        image = "ghcr.io/ente-io/server:${cfg.version.museum}";
        volumes = [
           "${cfg.dataLocation}/custom-logs:/var/logs"
           "${cfg.dataLocation}/museum.yaml:/museum.yaml:ro"
           "${cfg.dataLocation}/credentials.yaml:/credentials.yaml:ro"
           "${cfg.options.mediaLocation}/images/ente:/data:ro"
        ];
        ports = [
          "${toString cfg.uiPort}:8080"
        ];
        environment = {
          ENTE_CREDENTIALS_FILE = "/credentials.yaml";
        };
        extraOptions = [
          "--network-alias=museum"
          "--network=ente-internal"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "ente";
                "homepage.name" = "ente";
                "homepage.icon" = "ente";
                "homepage.href" = "https://ente.${cfg.traefik.urlBase}";
                "homepage.description" = "Full text ente generator";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.ente.rule" = "Host(`ente.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.ente.entrypoints" = "websecure";
                "traefik.http.routers.ente.tls.certresolver" = "porkbun";
                "traefik.http.services.ente.loadbalancer.server.port" = "8080";
              }
            else
              { }
          );
      };
        containers.postgres-ente = {
          hostname = "postgres-ente";
          image = "postgres:${cfg.version.postgres}";

          volumes = [
            "${cfg.dataLocation}/postgres:/var/lib/postgresql/data"
          ];
          ports = [
            "5432:5432"
          ];
          environment = {
            POSTGRES_DB = "ente-db";
            PGUSER = "ente";
            POSTGRES_PASSWORD = "onto";
          };
          extraOptions = [
          "--network-alias=postgres"
          "--network=ente-internal"
          "--ip=10.89.0.10"
          ];
        };
  containers."ente-minio" = {
    image = "minio/minio:${cfg.version.minio}";
    environment = {
      "MINIO_ROOT_PASSWORD" = "monootest";
      "MINIO_ROOT_USER" = "minio";
    };
    volumes = [
      "${cfg.options.mediaLocation}/images/ente:/data:rw"
    ];
    ports = [
      "3200:3200/tcp"
      "3201:3201/tcp"
    ];
    cmd = [ "server" "/data" "--address" ":3200" "--console-address" ":3201" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=minio"
      "--network=ente-internal"
    ];
  };
  containers."ente-minio-provision" = {
    image = "minio/mc:${cfg.version.mc}";
    volumes = [
      "${cfg.dataLocation}/minio-provision.sh:/provision.sh:ro"
      "${cfg.options.mediaLocation}/images/ente:/data:rw"
    ];
    dependsOn = [
      "ente-minio"
    ];
    log-driver = "journald";
    extraOptions = [
      "--entrypoint=[\"sh\", \"/provision.sh\"]"
      "--network-alias=minio-provision"
      "--network=ente-internal"
    ];
  };
  containers."ente-socat" = {
    image = "alpine/socat:${cfg.version.socat}";
    cmd = [ "TCP-LISTEN:3200,fork,reuseaddr" "TCP:minio:3200" ];
    dependsOn = [
      "ente-museum"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network=container:ente-museum"
    ];
  };
    };
    networking.firewall.allowedTCPPorts = [ cfg.uiPort ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/data 0770 osmo users - -"
      "d ${cfg.dataLocation}/postgres 0770 osmo users - -"
      "d ${cfg.dataLocation}/custom-logs 0770 osmo users - -"
    ];
  systemd.services."podman-network-ente-internal" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f ente-internal";
    };
    script = ''
      podman network inspect ente-internal || podman network create ente-internal
    '';
    partOf = [ "podman-compose-ente-root.target" ];
    wantedBy = [ "podman-compose-ente-root.target" ];
  };
  };
}
