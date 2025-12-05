{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.containers.silverbullet;
in
{
  options.services.containers.silverbullet = {
    enable = mkEnableOption "Enable silverbullet";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/silverbullet";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
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
      urlBase = mkOption {
        type = types.str;
        default = "klusteri-2.kotiserweri.zip";
      };
    };
    newt = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.silverbullet = {
        hostname = "silverbullet";
        image = "ghcr.io/silverbulletmd/silverbullet:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/space"
        ];
        ports = [
          "${toString cfg.uiPort}:3000"
        ];
        environment = {
        };
        extraOptions =
          if cfg.newt.enable == true then
            [
              "--network=container:newt"
            ]
          else
            [
              "--network-alias=cinny"
            ];
        dependsOn = optional cfg.newt.enable "newt";
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Productivity";
                "homepage.name" = "silverbullet";
                "homepage.icon" = "silverbullet.png";
                "homepage.href" = "https://silverbullet.klusteri-2.kotiserweri.zip";
                "homepage.description" = "Note taking web application";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.silverbullet.rule" = "Host(`silverbullet.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.silverbullet.entrypoints" = "websecure";
                "traefik.http.routers.silverbullet.tls.certresolver" = "porkbun";
                "traefik.http.services.silverbullet.loadbalancer.server.port" = "3000";
              }
            else
              { }
          );
      };
    };
    networking.firewall.allowedUDPPorts = [ cfg.uiPort ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
