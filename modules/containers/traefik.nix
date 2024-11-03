{ lib, config, ... }:
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
    enableTraefik = mkOption {
      type = types.bool;
      default = true;
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."containers/traefik-token" = {};
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
	  DUCKDNS_TOKEN_FILE = "${config.sops.secrets."containers/traefik-token".path}";
	};
	volumes = [
	  "${cfg.dataLocation}:/letsencrypt"
	];
        cmd = [
                "--api.insecure=true" # Optional: enables the Traefik dashboard (disabled in production)
      "--api.dashboard=true"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false" # only expose containers explicitly
        "--providers.docker.endpoint=tcp://192.168.11.10:2375" # Use the proxy instead of the direct socket
        #"--providers.docker.endpoint=tcp://192.168.11.11:2375" # Use the proxy instead of the direct socket
      "--entrypoints.web.address=:80"
            "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      "--entrypoints.websecure.address=:443"
      # Set up the TLS configuration for our websecure listener
      "--entrypoints.websecure.http.tls=true"
      "--entrypoints.websecure.http.tls.certResolver=letsencrypt"
      #"--entrypoints.websecure.http.tls.domains[0].main=testeri.duckdns.org"
      #"--entrypoints.websecure.http.tls.domains[0].sans=*.testeri.duckdns.org"
      #"--certificatesresolvers.duckdns.acme.domains[0].main=testeri.duckdns.org"
      #"--certificatesresolvers.duckdns.acme.domains[0].sans=*.testeri.duckdns.org"
      "--entrypoints.websecure.address=:443"
	"--certificatesresolvers.duckdns.acme.email=osmo@osmo.zip"
	"--certificatesresolvers.duckdns.acme.storage=/letsencrypt/acme.json"
	"--certificatesresolvers.duckdns.acme.dnschallenge.provider=duckdns"
	#"--certificatesresolvers.duckdns.acme.dnschallenge.resolvers=8.8.8.8:53,1.1.1.1:53"
	"--certificatesresolvers.duckdns.acme.dnschallenge.delaybeforecheck=120"
	"--certificatesresolvers.duckdns.acme.caserver=https://acme-v02.api.letsencrypt.org/directory"
	#"--certificatesresolvers.duckdns.acme.domains=*.testeri.duckdns.org,testeri.duckdns.org"
      "--log.level=DEBUG"
	];
labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "Network";
          "homepage.name" = "Traefik";
          "homepage.icon" = "traefik.png";
          # TODO: Change this.
          "homepage.href" = "https://traefik.osmo1.duckdns.org";
          "homepage.description" = "Reverse proxies";
    } else {} ) //

    (if cfg.enableTraefik == true then {
      "traefik.enable" = "true";
      "traefik.http.routers.traefik.rule" = "Host(`traefik.testeri.duckdns.org`)";
      "traefik.http.routers.traefik.entrypoints" = "websecure";
      "traefik.http.routers.traefik.tls.certresolver" = "duckdns";
      "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
    } else {} );

      extraOptions = ["--network=default"];
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

