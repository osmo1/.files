{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.vaultwarden;
in
{
  options.services.containers.vaultwarden = {
    enable = mkEnableOption "Enable vaultwarden password manager";
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
      default = "${config.users.users.osmo.home}/vaultwarden";
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
    virtualisation.oci-containers.containers."vaultwarden" = {
      image = "vaultwarden/server:${cfg.version}";
      # Need rootless
      # user = "1000:100";

      ports = [
        "${toString cfg.ports.ui}:80/tcp"
      ];
      volumes = [
        "${cfg.volume}:/data"
      ];
      environment = {
        DOMAIN = "https://vault.${cfg.traefik.urlBase}";
        SIGNUPS_ALLOWED = "false"; # Create your user in the admin panel
      };
      environmentFiles = [ "${config.sops.secrets.vaultwarden.path}" ];

      labels =
        (
          if cfg.enableHomePage == true then
            {
              "homepage.group" = "Services";
              "homepage.name" = "Vaultwarden";
              "homepage.icon" = "vaultwarden";
              "homepage.href" = "https://vault.${cfg.traefik.urlBase}";
              "homepage.description" = "Password manager";
            }
          else
            { }
        )
        // (
          if cfg.traefik.enable == true then
            {
              "traefik.enable" = "true";
              "traefik.http.routers.vaultwarden.rule" = "Host(`vault.${cfg.traefik.urlBase}`)";
              "traefik.http.routers.vaultwarden.entrypoints" = "websecure";
              "traefik.http.routers.vaultwarden.tls.certresolver" = "porkbun";
              "traefik.http.services.vaultwarden.loadbalancer.server.port" = "80";
            }
          else
            { }
        );
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.volume} 0770 osmo users - -"
    ];

    # Secrets
    sops.secrets.vaultwarden = {
      sopsFile = "${builtins.toString inputs.secrets}/docker.yaml";
      restartUnits = [ "podman-vaultwarden.service" ];
      owner = "osmo";
      group = "users";
    };
  };
}
