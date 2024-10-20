{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.containers.homepage;
in {
  options.services.containers.homepage = {
    enable = mkEnableOption "Enable homepage minecraft controller";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      # TODO: This needs to be changed.
      default = "${config.users.users.osmo.home}/homepage";
    };
    uiPort = mkOption {
      type = types.port;
      default = 80;
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.homepage = {
        hostname = "homepage";
        image = "ghcr.io/gethomepage/homepage:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/app/config"
        ];
        ports = [
          "${toString cfg.uiPort}:3000"
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.uiPort ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}

