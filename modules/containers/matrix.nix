{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.matrix;
in
{
  options.services.containers.matrix = {
    enable = mkEnableOption "Enable the matrix server conduwuit";
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
      default = "${config.users.users.osmo.home}/matrix";
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
      containers.matrix = {
        hostname = "matrix";
        image = "ghcr.io/girlbossceo/conduwuit:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}/db:/var/lib/conduit"
          "${cfg.dataLocation}/conduwuit.toml:/etc/conduwuit.toml"
        ];
        ports = [
          "${toString cfg.matrixUiPort}:6167"
        ];
        environment = {
          CONDUWUIT_SERVER_NAME = "your.server.name.example";
          CONDUWUIT_DATABASE_PATH = "/var/lib/conduwuit";
          CONDUWUIT_PORT = "6167"; # should match the loadbalancer traefik label
          CONDUWUIT_MAX_REQUEST_SIZE = "20000000"; # in bytes, ~20 MB
          CONDUWUIT_ALLOW_REGISTRATION = "true";
          CONDUWUIT_ALLOW_FEDERATION = "true";
          CONDUWUIT_ALLOW_CHECK_FOR_UPDATES = "true";
          CONDUWUIT_TRUSTED_SERVERS = "[ 'matrix.org' 'envs.net' ]";
          #CONDUWUIT_LOG = "warn,state_res=warn"
          CONDUWUIT_ADDRESS = "0.0.0.0";
          CONDUWUIT_CONFIG = "/etc/conduwuit.toml"; # Uncomment if you mapped config toml above
        };
        extraOptions = [
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "matrix";
                "homepage.name" = "matrix";
                "homepage.icon" = "matrix";
                "homepage.href" = "https://matrix.${cfg.traefik.urlBase}";
                "homepage.description" = "Matrix homeserver";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.matrix.rule" = "Host(`matrix.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.matrix.entrypoints" = "websecure";
                "traefik.http.routers.matrix.tls.certresolver" = "porkbun";
                "traefik.http.services.matrix.loadbalancer.server.port" = "6167";
              }
            else
              { }
          );
      };
    };
    networking.firewall.allowedTCPPorts = [
      cfg.matrixUiPort
      cfg.freshUiPort
    ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
