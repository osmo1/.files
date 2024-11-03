{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.containers.pihole;
in {
  options.services.containers.pihole = {
    enable = mkEnableOption "Enable pihole";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      # TODO: This needs to be changed.
      default = "${config.users.users.osmo.home}/pihole";
    };
    uiPort = mkOption {
      type = types.port;
      default = 480;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
    };
    enableTraefik = mkOption {
      type = types.bool;
      default = true;
    };
    options = {};
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.pihole = {
        hostname = "pihole";
        image = "pihole/pihole:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}/pihole:/etc/pihole"
          "${cfg.dataLocation}/dnsmasq.d:/etc/dnsmasq.d"
        ];
        ports = [
	       "53:53"
	       "53:53/udp"
	       "${toString cfg.uiPort}:80"
        ];
        environment = {
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
	  "--network=default"
        ];
labels =    (if cfg.enableHomePage == true then {
      "homepage.group" = "Network";
      "homepage.name" = "Pihole";
      "homepage.icon" = "pihole";
      "homepage.href" = "https://pihole.klusteri-0.kotiserweri.zip"; # TODO: Change this.
      "homepage.description" = "DNS blocking";
    } else {} ) //

    (if cfg.enableTraefik == true then {
      "traefik.enable" = "true";
      "traefik.http.routers.pihole.rule" = "Host(`pihole.klusteri-0.kotiserweri.zip`)";
      "traefik.http.routers.pihole.entrypoints" = "websecure";
      "traefik.http.routers.pihole.tls.certresolver" = "porkbun";
      "traefik.http.services.pihole.loadbalancer.server.port" = "80";
      # Redirect to /admin
      #"traefik.http.middlewares.pihole-addprefix.addprefix.prefix" = "/admin";
     # "traefik.http.routers.pihole.middlewares" = "pihole-addprefix";
    } else {} );


      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.uiPort ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/pihole 0770 osmo users - -"
      "d ${cfg.dataLocation}/dnsmasq.d 0770 osmo users - -"
    ];
  };
}

