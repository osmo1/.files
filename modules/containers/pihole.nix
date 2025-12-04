{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.containers.pihole;
in
{
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
      default = 8080;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
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
    options = { };
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
          # "53:53"
          # "53:53/udp"
          "${toString cfg.uiPort}:80"
        ];
        environment = {
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
          "--network=default"
          "--publish=192.168.11.10:53:53"
          "--publish=192.168.11.10:53:53/udp"
          # "--network=net_macvlan"
          # "--ip=192.168.11.10"
          # "--mac-address=32:ce:89:84:8c:69"
        ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Network";
                "homepage.name" = "Pihole";
                "homepage.icon" = "pihole";
                "homepage.href" = "https://pihole.${cfg.traefik.baseUrl}";
                "homepage.description" = "DNS blocking";
              }
            else
              { }
          )
          //

            (
              if cfg.traefik.enable == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.pihole.rule" = "Host(`pihole.${cfg.traefik.baseUrl}`)";
                  "traefik.http.routers.pihole.entrypoints" = "websecure";
                  "traefik.http.routers.pihole.tls.certresolver" = "porkbun";
                  "traefik.http.services.pihole.loadbalancer.server.port" = "80";
                  # Redirect to /admin
                  #"traefik.http.middlewares.pihole-addprefix.addprefix.prefix" = "/admin";
                  # "traefik.http.routers.pihole.middlewares" = "pihole-addprefix";
                }
              else
                { }
            );

      };
    };
    # To edit use your text editor application, for example Nano
    # systemd.services."podman-network-pihole" = {
    #   path = [ pkgs.podman ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #     ExecStop = "podman network rm -f net_macvlan";
    #   };
    #   partOf = [ "default.target" ];
    #   wantedBy = [ "default.target" ];
    #   script = ''podman network exists net_macvlan || podman network create --driver=macvlan --gateway=192.168.11.2 --subnet=192.168.11.0/24 -o parent=eno2 net_macvlan'';
    # };

    networking.firewall.allowedTCPPorts = [ cfg.uiPort ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/pihole 0770 osmo users - -"
      "d ${cfg.dataLocation}/dnsmasq.d 0770 osmo users - -"
    ];
  };
}
