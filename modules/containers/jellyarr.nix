{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.containers.jellyarr;
in {
  options.services.containers.jellyarr = {
    enable = mkEnableOption "Enable jellyfin, *arr services and deluge";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      # TODO: This needs to be changed.
      default = "${config.users.users.osmo.home}/jellyarr";
    };
    uiPortStart = mkOption {
      type = types.port;
      default = 2080;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Etc/UTC";
    };
    enableHomePage = mkOption {
      type = types.bool;
      default = true;
    };
    #options = {};
  };

  config =
  let
    startPort = 25500 + cfg.options.portOffset;
    endPort = 25600 + cfg.options.portOffset;
    portRange = "${toString startPort}-${toString endPort}:${toString startPort}-${toString endPort}/tcp";
    singlePortString = "${toString cfg.options.singlePort}:${toString cfg.options.singlePort}";
  in mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.prowlarr = {
        hostname = "prowlarr";
        image = "lscr.io/linuxserver/prowlarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/prowlarr:/config"
        ];
        ports = [
          "${toString cfg.uiPortStart}:6969"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.sonarr = {
        hostname = "sonarr";
        image = "lscr.io/linuxserver/sonarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/sonarr:/config"
          "${cfg.dataLocation}/media/tv:/tv"
          "${cfg.dataLocation}/downloads:/downloads"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 100) }:8989"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.radarr = {
        hostname = "radarr";
        image = "lscr.io/linuxserver/radarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/radarr:/config"
          "${cfg.dataLocation}/media/movies:/movies"
          "${cfg.dataLocation}/downloads:/downloads"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 200) }:7878"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.lidarr = {
        hostname = "lidarr";
        image = "lscr.io/linuxserver/lidarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/lidarr:/config"
          "${cfg.dataLocation}/media/music:/music"
          "${cfg.dataLocation}/downloads:/downloads"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 300) }:8686"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.readarr = {
        hostname = "readarr";
        image = "lscr.io/linuxserver/readarr:develop";
	
        volumes = [
          "${cfg.dataLocation}/readarr:/config"
          "${cfg.dataLocation}/media/books:/books"
          "${cfg.dataLocation}/downloads:/downloads"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 400) }:8787"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.bazarr = {
        hostname = "bazarr";
        image = "lscr.io/linuxserver/bazarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/bazarr:/config"
          "${cfg.dataLocation}/media/movies:/movies"
          "${cfg.dataLocation}/media/tv:/tv"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 500) }:6767"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.jellyfin = {
        hostname = "jellyfin";
        image = "lscr.io/linuxserver/jellyfin:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/jellyfin:/config"
          "${cfg.dataLocation}/media/movies:/data/movies"
          "${cfg.dataLocation}/media/tv:/data/tvshows"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 600) }:8096"
	  "7359:7359/udp"
	  "1900:1900"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.overseerr = {
        hostname = "overseerr";
        image = "lscr.io/linuxserver/overseerr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/overseerr:/config"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 700) }:5055"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
      containers.qbittorrent = {
        hostname = "qbittorrent";
        image = "lscr.io/linuxserver/qbittorrent:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/qbittorrent:/config"
          "${cfg.dataLocation}/downloads:/downloads"
        ];
        ports = [
          "${toString (cfg.uiPortStart + 800) }:8080"
	  "6881:6881"
	  "6881:6881/udp"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
	  UMASK = "002";
	  WEBUI_PORT = "8080";
	  TORRENTING_PORT = "6881";
        };
        extraOptions = [
        ];
	#TODO all of these homepages
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
    networking.firewall.allowedTCPPorts = [ cfg.uiPortStart ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/downloads 0770 osmo users - -"
      "d ${cfg.dataLocation}/qbittorrent 0770 osmo users - -"
      "d ${cfg.dataLocation}/prowlarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/sonarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/radarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/lidarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/readarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/bazarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/overseerr 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyfin 0770 osmo users - -"
      "d ${cfg.dataLocation}/media 0770 osmo users - -"
      "d ${cfg.dataLocation}/media/movies 0770 osmo users - -"
      "d ${cfg.dataLocation}/media/tv 0770 osmo users - -"
      "d ${cfg.dataLocation}/media/books 0770 osmo users - -"
      "d ${cfg.dataLocation}/media/music 0770 osmo users - -"
    ];
    #systemd.services.podman-jellyarr.serviceConfig.User = "osmo";
  };
}

