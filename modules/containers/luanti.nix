{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.containers.luanti;
in
{
  options.services.containers.luanti = {
    enable = mkEnableOption "Enable luanti server";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      # TODO: This needs to be changed.
      default = "${config.users.users.osmo.home}/luanti";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
    };
    options = {
      /*
        portOffset = lib.mkOption {
          type = types.int;
          default = 0;
          description = "Offset to apply to the base port. Can be a positive or negative integer.";
        };
        enableRcon = mkOption {
          type = types.bool;
          default = true;
        };
        enableSinglePort = mkOption {
          type = types.bool;
          default = false;
          description = "Enable a single port instead of a port range.";
        };
      */
      hostPort = mkOption {
        type = types.str;
        default = "192.168.1.1";
        description = "Local host port for the container config";
      };
      singlePort = mkOption {
        type = types.int;
        default = 25565;
        description = "Single port to use when enableSinglePort is true.";
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.luanti = {
        hostname = "luanti";
        image = "registry.gitlab.com/luanti-controller/luanti-4:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/config/.minetest"
        ];
        ports = [
          "${toString cfg.options.singlePort}:30000"
        ];
        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
          CLI_ARGS = "--gameid mineclone";
        };
        extraOptions = [
        ];
        labels = mkIf cfg.enableHomePage {
          "homepage.group" = "Misc";
          "homepage.name" = "luanti";
          "homepage.icon" = "luanti.png";
          "homepage.href" = "https://luanti.klusteri-1.serweri.zip";
          "homepage.description" = "Luanti server";
        };
      };
    };
    networking.firewall = {
      allowedUDPPorts = [ cfg.options.singlePort ];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
