{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.bento;
in
{
  options.services.containers.bento = {
    enable = mkEnableOption "Enable bento pdf tool";
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
    virtualisation.oci-containers.containers."bento" = {
      image = "bentopdf/bentopdf-simple:${cfg.version}";
      # Need rootless
      # user = "1000:100";

      ports = [
        "${toString cfg.ports.ui}:8080/tcp"
      ];

      labels =
        (
          if cfg.enableHomePage == true then
            {
              "homepage.group" = "Services";
              "homepage.name" = "Bento";
              "homepage.icon" = "bentopdf";
              "homepage.href" = "https://bento.${cfg.traefik.urlBase}";
              "homepage.description" = "PDF tools";
            }
          else
            { }
        )
        // (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.bento.rule" = "Host(`bento.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.bento.entrypoints" = "websecure";
              "traefik.http.routers.bento.tls.certresolver" = "porkbun";
              "traefik.http.services.bento.loadbalancer.server.port" = "8080";
            }
          else
            { }
        );
    };
  };
}
