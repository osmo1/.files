{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.containers.dockerproxy;
in {
  options.services.containers.dockerproxy = {
    enable = mkEnableOption "Enable dockerproxy minecraft controller";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.dockerproxy = {
        hostname = "dockerproxy";
        image = "ghcr.io/tecnativa/docker-socket-proxy:${cfg.version}";
        volumes = [
	  "/var/run/podman/podman.sock:/var/run/docker.sock:ro" # Mounted as read-only
        ];
        ports = [
	  "2375:2375"
	];
        environment = {
	  CONTAINERS = "1"; 
	  SERVICES = "1";
          TASKS = "1";
          POST = "0";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 2375 ];
  };
}

