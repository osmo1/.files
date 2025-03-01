{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.traefik;
in
{
  options.services.containers.traefik = {
    enable = mkEnableOption "Enable traefik reverse proxy manager";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/traefik";
    };
    uiPort = mkOption {
      type = types.port;
      default = 380;
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
    };
    enableTraefik = mkOption {
      type = types.bool;
      default = true;
    };
    options = {
      url = mkOption {
        type = types.str;
        default = "kotiserweri.zip";
      };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."containers/traefik-api" = {
      owner = "osmo";
      group = "users";
      mode = "700";
    };
    sops.secrets."containers/traefik-secret" = {
      owner = "osmo";
      group = "users";
      mode = "700";
    };
    virtualisation.oci-containers = {
      containers.traefik = {
        hostname = "traefik";
        image = "traefik:${cfg.version}";
        ports = [
          "80:80"
          "443:443"
          "${toString cfg.uiPort}:8080"
        ];
        environment = {
          PORKBUN_API_KEY_FILE = "/keys/traefik-api";
          PORKBUN_SECRET_API_KEY_FILE = "/keys/traefik-secret";
        };
        volumes = [
          "${cfg.dataLocation}/config:/config"
          "${cfg.dataLocation}/certs:/letsencrypt"
          "/var/run/secrets/containers/traefik-api:/keys/traefik-api"
          "/var/run/secrets/containers/traefik-secret:/keys/traefik-secret"
        ];
        cmd = [
          "--api.insecure=true"
          "--api.dashboard=true"
          "--providers.file.directory=/config"
          "--providers.file.watch=true"
          "--providers.docker=true"
          "--providers.docker.exposedbydefault=false"
          "--providers.docker.endpoint=tcp://${
            if config.networking.hostName == "klusteri-0" then
              "192.168.11.10"
            else if config.networking.hostName == "klusteri-1" then
              "192.168.11.11"
            else if config.networking.hostName == "klusteri-2" then
              "192.168.11.12"
            else
              "192.168.11.200"
          }:2375" # Use the proxy instead of the direct socket
          "--entrypoints.web.address=:80"
          "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          "--entrypoints.websecure.address=:443"
          "--entrypoints.websecure.http.tls=true"
          "--entrypoints.websecure.http.tls.certResolver=letsencrypt"
          "--entrypoints.websecure.address=:443"
          "--certificatesresolvers.porkbun.acme.email=osmo@osmo.zip"
          "--certificatesresolvers.porkbun.acme.storage=/letsencrypt/acme.json"
          "--certificatesresolvers.porkbun.acme.dnschallenge.provider=porkbun"
          "--certificatesresolvers.porkbun.acme.dnschallenge.delaybeforecheck=120"
          "--certificatesresolvers.porkbun.acme.caserver=https://acme-v02.api.letsencrypt.org/directory"
          "--log.level=DEBUG"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Network";
                "homepage.name" = "Traefik";
                "homepage.icon" = "traefik.png";
                "homepage.href" = "https://traefik.${cfg.options.url}";
                "homepage.description" = "Reverse proxies";
              }
            else
              { }
          )
          //

            (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.traefik.rule" = "Host(`traefik.${cfg.options.url}`)";
                  "traefik.http.routers.traefik.entrypoints" = "websecure";
                  "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
                  "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
                }
              else
                { }
            );

        extraOptions = [ "--network=default" ];
      };
    };
    networking.firewall.allowedTCPPorts = [
      cfg.uiPort
      80
      443
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/keys 0770 osmo users - -"
      "d ${cfg.dataLocation}/certs 0770 osmo users - -"
      "d ${cfg.dataLocation}/config 0770 osmo users - -"
    ];
    #systemd.services.podman-traefik.serviceConfig.User = "osmo";
  };
}
