{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.containers.homepage;
in
{
  options.services.containers.homepage = {
    enable = mkEnableOption "Enable homepage, a dashboard for your services";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      # TODO: This needs to be changed.
      default = "${config.users.users.osmo.home}/homepage";
    };
    uiPort = mkOption {
      type = types.port;
      default = 80;
    };
    traefik = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      baseUrl = mkOption {
        type = types.str;
        default = "klusteri-0.serweri.zip";
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.homepage = {
        hostname = "homepage";
        image = "ghcr.io/gethomepage/homepage:${cfg.version}";
        podman.user = "osmo";
        volumes = [
          "${cfg.dataLocation}:/app/config"
        ];
        ports = [
          "${toString cfg.uiPort}:3000"
        ];
        environment = {
          HOMEPAGE_ALLOWED_HOSTS = "home.${cfg.traefik.baseUrl},192.168.11.10:180";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.homepage.rule" = "Host(`home.${cfg.traefik.baseUrl}`)";
          "traefik.http.routers.homepage.entrypoints" = "websecure";
          "traefik.http.routers.homepage.tls.certresolver" = "porkbun";
          "traefik.http.services.homepage.loadbalancer.server.port" = "3000";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.uiPort ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
