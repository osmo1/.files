{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.containers.traefik;
in {
  options.services.containers.traefik = {
    enable = mkEnableOption "Enable traefik minecraft controller";
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
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.traefik = {
        hostname = "traefik";
        image = "traefik:v${cfg.version}";
        ports = [
	  "80:80"
	  "443:443"
	  "${cfg.uiPort}:8080"
        ];
	volumes = [
	  "${cfg.dataLocation}:/letsencrypt"
	];
        cmd = [
                "--api.insecure=true" # Optional: enables the Traefik dashboard (disabled in production)
      "--api.dashboard=true"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false" # only expose containers explicitly
        "--providers.docker.endpoint=tcp://192.168.11.10:2375" # Use the proxy instead of the direct socket
        "--providers.docker.endpoint=tcp://192.168.11.11:2375" # Use the proxy instead of the direct socket
      "--entrypoints.web.address=:80"
      "--entrypoints.websecure.address=:443"
      "--certificatesresolvers.duckdns.acme.dnschallenge=true"
      "--certificatesresolvers.duckdns.acme.dnschallenge.provider=duckdns"
      #"--certificatesresolvers.duckdns.acme.email=your-email@example.com" # use your email
      "--certificatesresolvers.duckdns.acme.storage=/letsencrypt/acme.json"
      "--log.level=INFO"
	];
        labels = mkIf cfg.enableHomePage {
          "homepage.group" = "Network";
          "homepage.name" = "Traefik";
          "homepage.icon" = "traefik.png";
          # TODO: Change this.
          "homepage.href" = "https://traefik.osmo1.duckdns.org";
          "homepage.description" = "Reverse proxies";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.uiPort 80 443 ];
    
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/backups 0770 osmo users - -"
      "d ${cfg.dataLocation}/logs 0770 osmo users - -"
      "d ${cfg.dataLocation}/servers 0770 osmo users - -"
      "d ${cfg.dataLocation}/config 0770 osmo users - -"
      "d ${cfg.dataLocation}/import 0770 osmo users - -"
    ];
    #systemd.services.podman-traefik.serviceConfig.User = "osmo";
  };
}

