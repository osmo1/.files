{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.stirling;
in
{
  options.services.containers.stirling = {
    enable = mkEnableOption "Enable stirling pdf tool";
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
      default = "${config.users.users.osmo.home}/stirling";
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
    virtualisation.oci-containers.containers."stirling" = {
      image = "docker.stirlingpdf.com/stirlingtools/stirling-pdf:${cfg.version}";
      # Need rootless
      # user = "1000:100";

      ports = [
        "${toString cfg.ports.ui}:8080/tcp"
      ];
      volumes = [
        "${cfg.volume}/trainingData:/usr/share/tessdata"
        "${cfg.volume}/extraConfigs:/configs"
        "${cfg.volume}/customFiles:/customFiles/"
        "${cfg.volume}/logs:/logs/"
        "${cfg.volume}/pipeline:/pipeline/"
      ];
      environment = {
        LANGS = "en_GB";
      };
      # environmentFiles = [ "${config.sops.secrets.stirling.path}" ];

      labels =
        (
          if cfg.enableHomePage == true then
            {
              "homepage.group" = "Services";
              "homepage.name" = "Stirling";
              "homepage.icon" = "stirling-pdf";
              "homepage.href" = "https://stirling.${cfg.traefik.urlBase}";
              "homepage.description" = "PDF tools";
            }
          else
            { }
        )
        // (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.stirling.rule" = "Host(`stirling.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.stirling.entrypoints" = "websecure";
              "traefik.http.routers.stirling.tls.certresolver" = "porkbun";
              "traefik.http.services.stirling.loadbalancer.server.port" = "8080";
            }
          else
            { }
        );
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.volume} 0770 osmo users - -"
      "d ${cfg.volume}/trainingData 0770 osmo users - -"
      "d ${cfg.volume}/extraConfigs 0770 osmo users - -"
      "d ${cfg.volume}/customFiles 0770 osmo users - -"
      "d ${cfg.volume}/logs 0770 osmo users - -"
      "d ${cfg.volume}/pipeline 0770 osmo users - -"
    ];
  };
}
