{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.convertx;
in
{
  options.services.containers.convertx = {
    enable = mkEnableOption "Enable convertx file converter";
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
      default = "${config.users.users.osmo.home}/convertx";
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
    virtualisation.oci-containers.containers."convertx" = {
      image = "ghcr.io/c4illin/convertx:${cfg.version}";
      # Need rootless
      # user = "1000:100";

      ports = [
        "${toString cfg.ports.ui}:3000/tcp"
      ];
      volumes = [
        "${cfg.volume}:/app/data"
      ];

      labels =
        (
          if cfg.enableHomePage == true then
            {
              "homepage.group" = "Services";
              "homepage.name" = "Convertx";
              "homepage.icon" = "convertx";
              "homepage.href" = "https://convert.${cfg.traefik.urlBase}";
              "homepage.description" = "File converter";
            }
          else
            { }
        )
        // (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.convertx.rule" = "Host(`convert.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.convertx.entrypoints" = "websecure";
              "traefik.http.routers.convertx.tls.certresolver" = "porkbun";
              "traefik.http.services.convertx.loadbalancer.server.port" = "3000";
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
