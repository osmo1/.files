{ lib, pkgs, config, ... }:
with lib;
let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.docker.crafty;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.hello = {
    enable = mkEnableOption "Crafty docker container";
    version = mkOption {
        type = types.str;
        default = "latest";
        description = ''
            Sets the tag for the docker image.
        '';
    };
    volumesBase = mkOption {
        type = types.str;
        default = "~/crafty";
    };
    webUIPort = mkOption {
        type = types.int;
        default = 80;
    };
  };

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
    	containers.crafty = {
    	    hostname = "crafty";
    	    image = "registry.gitlab.com/crafty-controller/crafty-4:${cfg.version}";
    	    volumes = [
    		"${cfg.volumesBase}/backups:/crafty/backups"
    		"${cfg.volumesBase}/logs:/crafty/logs"
    		"${cfg.volumesBase}/servers:/crafty/servers"
    		"${cfg.volumesbase}/config:/crafty/app/config"
    		"${cfg.volumesbase}/import:/crafty/import"
    	    ];
    	    ports = [
    		"${cfg.webUIPort}:8000"
    		"25500-25600:25500-25600/tcp"
    		"25575:25575"
    	    ];
    	    environment = {
    		TZ = config.timezone;
    	    };
    	    extraOptions = [
    		"--sysctl=net.ipv4.ip_forward=1"
    	    ];
    	};
    };
    networking.firewall = {
    	allowedTCPPorts = [ ${cfg.webUIPort} 25575];
    	allowedTCPPortRanges = [{
    	    from = 25500;
    	    to = 25600;
    	}];
    };
};
}
