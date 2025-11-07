{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.anisette;
in
{
  options.services.containers.anisette = {
    enable = mkEnableOption "Enable anisette for iOS sideloading";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    ports = {
      connect = mkOption {
        type = types.port;
        default = 6969;
      };
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/anisette";
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
    virtualisation.oci-containers = {
      containers.anisette = {
        hostname = "anisette";
        image = "dadoum/anisette-v3-server:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/home/Alcoholic/.config/anisette-v3/lib/"
        ];
        ports = [
          "${toString cfg.ports.connect}:6969"
        ];
        environment = {
        };
        extraOptions = [
        ];
        # Prolly not needed
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Anisette";
                "homepage.name" = "Anisette";
                "homepage.icon" = "Anisette";
                "homepage.href" = "https://anisette.${cfg.traefik.urlBase}";
                "homepage.description" = "Anisette server for iOS sideloading";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.anisette.rule" = "Host(`anisette.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.anisette.entrypoints" = "websecure";
                "traefik.http.routers.anisette.tls.certresolver" = "porkbun";
                "traefik.http.services.anisette.loadbalancer.server.port" = "6969";
              }
            else
              { }
          );
      };
    };
    networking.firewall.allowedTCPPorts = builtins.attrValues cfg.ports;
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
