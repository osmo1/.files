{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.containers.crafty;
in {
  options.services.containers.crafty = {
    enable = mkEnableOption "Enable crafty minecraft controller";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      # TODO: This needs to be changed.
      default = "${config.users.users.osmo.home}/crafty";
    };
    uiPort = mkOption {
      type = types.port;
      default = 380;
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
      singlePort = mkOption {
        type = types.int;
        default = 25565;
        description = "Single port to use when enableSinglePort is true.";
      };
    };
  };

  config =
  let
    startPort = 25500 + cfg.options.portOffset;
    endPort = 25600 + cfg.options.portOffset;
    portRange = "${toString startPort}-${toString endPort}:${toString startPort}-${toString endPort}/tcp";
    singlePortString = "${toString cfg.options.singlePort}:${toString cfg.options.singlePort}";
  in mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.crafty = {
        hostname = "crafty";
        image = "registry.gitlab.com/crafty-controller/crafty-4:${cfg.version}";
	user = "1000:100";
        volumes = [
          "${cfg.dataLocation}/backups:/crafty/backups"
          "${cfg.dataLocation}/logs:/crafty/logs"
          "${cfg.dataLocation}/servers:/crafty/servers"
          "${cfg.dataLocation}/config:/crafty/app/config"
          "${cfg.dataLocation}/import:/crafty/import"
        ];
        ports = [
          "${toString cfg.uiPort}:8443"
          (if cfg.options.enableSinglePort then singlePortString else portRange)
        ] ++ lib.optional cfg.options.enableRcon "25575:25575";
        environment = {
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
          "--sysctl=net.ipv4.ip_forward=1"
        ];
        labels = mkIf cfg.enableHomePage {
          "homepage.group" = "Misc";
          "homepage.name" = "Crafty";
          "homepage.icon" = "crafty.png";
          # TODO: Change this.
          "homepage.href" = "https://crafty.osmo1.duckdns.org";
          "homepage.description" = "Minecraft server";
          "homepage.widget.type" = "minecraft";
          "homepage.widget.url" = "udp://127.0.0.1:${toString cfg.options.singlePort}";
        };
      };
    };
    networking.firewall = {
      allowedTCPPorts = [ cfg.uiPort ] ++ lib.optional cfg.options.enableRcon 25575;
      allowedTCPPortRanges = [{
        from = startPort;
        to = endPort;
      }];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/backups 0770 osmo users - -"
      "d ${cfg.dataLocation}/logs 0770 osmo users - -"
      "d ${cfg.dataLocation}/servers 0770 osmo users - -"
      "d ${cfg.dataLocation}/config 0770 osmo users - -"
      "d ${cfg.dataLocation}/import 0770 osmo users - -"
    ];
    #systemd.services.podman-crafty.serviceConfig.User = "osmo";
  };
}

