{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.matrix;
in
{
  options.services.containers.matrix = {
    enable = mkEnableOption "Enable the matrix server Tuwunel";
    version = {
      tuwunel = mkOption {
        type = types.str;
        default = "v1.3.0";
      };
      cinny = mkOption {
        type = types.str;
        default = "v4.9.1";
      };
    };
    ports = {
      ui = mkOption {
        type = types.port;
        default = 80;
      };
      tuwunel = mkOption {
        type = types.port;
        default = 8443;
      };
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/matrix";
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
        default = false;
      };
      urlBase = mkOption {
        type = types.str;
        default = "klusteri-0.serweri.zip";
      };
    };
    newt = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      "tuwunel" = {
        hostname = "tuwunel";
        image = "ghcr.io/matrix-construct/tuwunel:${cfg.version.tuwunel}";
        environment = {
          "TUWUNEL_ADDRESS" = "0.0.0.0";
          "TUWUNEL_ALLOW_CHECK_FOR_UPDATES" = "true";
          "TUWUNEL_DATABASE_PATH" = "/var/lib/tuwunel";
          "TUWUNEL_MAX_REQUEST_SIZE" = "20000000";
          "TUWUNEL_PORT" = "6167";
          "TUWUNEL_SERVER_NAME" = "datapum.zip";
          "TUWUNEL_CONFIG" = "/etc/tuwunel.toml";
          # "TUWUNEL_TRUSTED_SERVERS" = "['matrix.org' 'envs.net']"; #?
        };
        volumes = [
          "${cfg.dataLocation}/tuwunel/db:/var/lib/tuwunel:rw"
          "${cfg.dataLocation}/tuwunel/db_backups:/db_backups:rw"
          "${cfg.dataLocation}/tuwunel.toml:/etc/tuwunel.toml"
          "${cfg.dataLocation}/key.key:/etc/key.key"
        ];
        ports = [
          "${toString cfg.ports.tuwunel}:6167/tcp"
        ];
        log-driver = "journald";
        extraOptions =
          if cfg.newt.enable == true then
            [
              "--network=container:newt"
            ]
          else
            [
              "--network-alias=tuwunel"
            ];
        dependsOn = optional cfg.newt.enable "newt";
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Public";
                "homepage.name" = "Tuwunel";
                "homepage.icon" = "element";
                # "homepage.href" = "https://matrix.${cfg.traefik.urlBase}";
                "homepage.description" = "Tuwunel matrix instance";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.matrix.rule" = "Host(`matrix.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.matrix.entrypoints" = "websecure";
                "traefik.http.routers.matrix.tls.certresolver" = "porkbun";
                "traefik.http.services.matrix.loadbalancer.server.port" = "6167";
              }
            else
              { }
          );
      };
      "cinny" = {
        hostname = "cinny";
        image = "ghcr.io/cinnyapp/cinny:${cfg.version.cinny}";
        environment = {
        };
        volumes = [
          "${cfg.dataLocation}/cinny-config.json:/app/config.json"
        ];
        ports = [
          "${toString cfg.ports.ui}:80/tcp"
        ];
        log-driver = "journald";
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
                "homepage.group" = "Public";
                "homepage.name" = "Cinny";
                "homepage.icon" = "cinny";
                "homepage.href" = "https://cinny.${cfg.traefik.urlBase}";
                "homepage.description" = "Cinny matrix webui";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.cinny.rule" = "Host(`cinny.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.cinny.entrypoints" = "websecure";
                "traefik.http.routers.cinny.tls.certresolver" = "porkbun";
                "traefik.http.services.cinny.loadbalancer.server.port" = "80";
              }
            else
              { }
          );
      };
      # "turn" = {
      #   hostname = "turn";
      #   image = "ghcr.io/turnapp/turn:${cfg.version.turn}";
      #   environment = {
      #   };
      #   volumes = [
      #     "${cfg.dataLocation}/turn-config.json:/app/config.json"
      #   ];
      #   ports = [
      #     "${toString cfg.ports.ui}:80/tcp"
      #   ];
      #   log-driver = "journald";
      #   extraOptions =
      #     if cfg.newt.enable == true then
      #       [
      #         "--network=container:newt"
      #       ]
      #     else
      #       [
      #         "--network-alias=turn"
      #       ];
      #   labels =
      #     (
      #       if cfg.enableHomePage == true then
      #         {
      #           "homepage.group" = "Public";
      #           "homepage.name" = "turn";
      #           "homepage.icon" = "turn";
      #           "homepage.href" = "https://turn.${cfg.traefik.urlBase}";
      #           "homepage.description" = "turn matrix webui";
      #         }
      #       else
      #         { }
      #     )
      #     // (
      #       if cfg.traefik.enable == true then
      #         {
      #           "traefik.enable" = "true";
      #           "traefik.http.routers.turn.rule" = "Host(`turn.${cfg.traefik.urlBase}`)";
      #           "traefik.http.routers.turn.entrypoints" = "websecure";
      #           "traefik.http.routers.turn.tls.certresolver" = "porkbun";
      #           "traefik.http.services.turn.loadbalancer.server.port" = "80";
      #         }
      #       else
      #         { }
      #     );
      # };
    };
    systemd.services."podman-matrix-tuwunel" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      partOf = [
        "podman-compose-matrix-root.target"
      ];
      wantedBy = [
        "podman-compose-matrix-root.target"
      ];
    };
    systemd.services."podman-matrix-cinny" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      partOf = [
        "podman-compose-matrix-root.target"
      ];
      wantedBy = [
        "podman-compose-matrix-root.target"
      ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-matrix-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
    networking.firewall.allowedTCPPorts = [
      cfg.ports.tuwunel
      cfg.ports.ui
    ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/tuwunel/db 0770 osmo users - -"
      "d ${cfg.dataLocation}/tuwunel/db_backups 0770 osmo users - -"
      "f ${cfg.dataLocation}/cinny-config.json 0770 osmo users - -"
      "f ${cfg.dataLocation}/tuwunel.toml 0770 osmo users - -"
      "f ${cfg.dataLocation}/key.key 0770 osmo users - -"
    ];
  };
}
