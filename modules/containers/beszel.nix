{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.beszel;
in
{
  options.services.containers.beszel = {
    enable = mkEnableOption "Enable beszel monitoring";
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
    volume = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/beszel";
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
    virtualisation.oci-containers.containers."beszel" = {
      image = "henrygd/beszel:${cfg.version}";
      environment = {
      };
      volumes = [
        "${cfg.volume}:/beszel_data"
      ];
      ports = [
        "${toString cfg.ports.ui}:8090/tcp"
      ];
      user = "1000:100";
      labels =
        (
          if cfg.enableHomePage == true then
            {
              "homepage.group" = "Services";
              "homepage.name" = "beszel";
              "homepage.icon" = "beszel";
              "homepage.href" = "https://beszel.${cfg.traefik.urlBase}";
              "homepage.description" = "beszel file server";
            }
          else
            { }
        )
        // (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.beszel.rule" = "Host(`beszel.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.beszel.entrypoints" = "websecure";
              "traefik.http.routers.beszel.tls.certresolver" = "porkbun";
              "traefik.http.services.beszel.loadbalancer.server.port" = "8090";
            }
          else
            { }
        );
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.volume} 0770 osmo users - -"
    ];
  };
}
