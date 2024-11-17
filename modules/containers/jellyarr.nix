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
    enableTraefik = mkOption {
      type = types.bool;
      default = true;
    };
    options = {
      urlBase = mkOption {
        type = types.str;
	default = "klusteri-1.kotiserweri.zip";
      };
      mediaLocation = mkOption {
        type = types.str;
        default = "/mnt/media";
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
    #services.containers.homepage = mkIf cfg.enableHomePage true;
    virtualisation.oci-containers = {
      /*containers.deluge = let
      	port = toString cfg.uiPortStart;
      in {
        hostname = "deluge";
        image = "lscr.io/linuxserver/deluge:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/deluge:/config"
          "${cfg.dataLocation}/downloads:/downloads"
        ];
        ports = [
          "${port}:8112"
	  "6881:6881"
	  "6881:6881/udp"
	  "58846:58846"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
	  DELUGE_LOGLEVEL = "error";
        };
        extraOptions = [
        ];
        labels = mkIf cfg.enableHomePage {
          "homepage.group" = "*arr";
          "homepage.name" = "Deluge";
          "homepage.icon" = "deluge.png";
          "homepage.href" = "https://deluge.${cfg.options.urlBase}";
          "homepage.description" = "Torrent client";
          "homepage.widget.type" = "deluge";
          "homepage.widget.url" = "https://127.0.0.1:${port}";
          "homepage.widget.password" = "osmo";
        };
      };*/
      containers.qbittorrent = let
      	port = toString cfg.uiPortStart;
      in {
        hostname = "qbittorrent";
        image = "lscr.io/linuxserver/qbittorrent:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/qbittorrent:/config"
          "${cfg.options.mediaLocation}/downloads:/downloads"
        ];
        ports = [
          "${port}:8080"
          "6881:6881"
	  "6881:6881/udp"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
	  WEBUI_PORT = "8080";
	  TORRENTING_PORT = "6881";
	  #DOCKER_MODS = "ghcr.io/vuetorrent/vuetorrent-lsio-mod:latest";
        };
        extraOptions = [
        ];

        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Deluge";
          "homepage.icon" = "deluge.png";
          "homepage.href" = "https://deluge.${cfg.options.urlBase}";
          "homepage.description" = "Torrent client";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`deluge.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
        } else {} );
      };
      containers.prowlarr = let
      	port = toString (cfg.uiPortStart + 100);
      in {
        hostname = "prowlarr";
        image = "lscr.io/linuxserver/prowlarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/prowlarr:/config"
        ];
        ports = [
          "${port}:9696"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Prowlarr";
          "homepage.icon" = "prowlarr";
          "homepage.href" = "https://prowlarr.${cfg.options.urlBase}";
          "homepage.description" = "Indexer distributor";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`prowlarr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "9696";
        } else {} );
      };
      containers.flaresolverr = let
      	port = toString (cfg.uiPortStart + 200);
      in {
        hostname = "flaresolverr";
        image = "ghcr.io/flaresolverr/flaresolverr:${cfg.version}";
        volumes = [
        ];
        ports = [
          "${port}:8191"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
      };
      containers.sonarr =  let
      	port = toString (cfg.uiPortStart + 300);
      in {
        hostname = "sonarr";
        image = "lscr.io/linuxserver/sonarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/sonarr:/config"
          "${cfg.options.mediaLocation}/tv:/tv"
          "${cfg.options.mediaLocation}/downloads:/downloads"
        ];
        ports = [
          "${port}:8989"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Sonarr";
          "homepage.icon" = "sonarr";
          "homepage.href" = "https://sonarr.${cfg.options.urlBase}";
          "homepage.description" = "Downloads and organizes TV shows";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`sonarr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8989";
        } else {} );
      }; 
      containers.radarr = let
      	port = toString (cfg.uiPortStart + 400);
      in {
        hostname = "radarr";
        image = "lscr.io/linuxserver/radarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/radarr:/config"
          "${cfg.options.mediaLocation}/movies:/movies"
          "${cfg.options.mediaLocation}/downloads:/downloads"
        ];
        ports = [
          "${port}:7878"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Radarr";
          "homepage.icon" = "radarr";
          "homepage.href" = "https://radarr.${cfg.options.urlBase}";
          "homepage.description" = "Downlads and organizes movies";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`radarr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "7878";
        } else {} );
      }; 
      containers.lidarr = let
      	port = toString (cfg.uiPortStart + 500);
      in {
        hostname = "lidarr";
        image = "lscr.io/linuxserver/lidarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/lidarr:/config"
          "${cfg.options.mediaLocation}/music:/music"
          "${cfg.options.mediaLocation}/downloads:/downloads"
        ];
        ports = [
          "${port}:8686"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "lidarr";
          "homepage.icon" = "lidarr";
          "homepage.href" = "https://lidarr.${cfg.options.urlBase}";
          "homepage.description" = "Downloads and organizes music";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`lidarr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8686";
        } else {} );
      };
      containers.readarr = let
      	port = toString (cfg.uiPortStart + 600);
      in {
        hostname = "readarr";
        image = "lscr.io/linuxserver/readarr:develop";
	
        volumes = [
          "${cfg.dataLocation}/readarr:/config"
          "${cfg.options.mediaLocation}/books:/books"
          "${cfg.options.mediaLocation}/downloads:/downloads"
        ];
        ports = [
          "${port}:8787"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Readarr";
          "homepage.icon" = "readarr";
          "homepage.href" = "https://readarr.${cfg.options.urlBase}";
          "homepage.description" = "Downloads and organizes literature";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`readarr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8787";
        } else {} );
      };
      containers.bazarr = let
      	port = toString (cfg.uiPortStart + 700);
      in {
        hostname = "bazarr";
        image = "lscr.io/linuxserver/bazarr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/bazarr:/config"
          "${cfg.options.mediaLocation}/movies:/movies"
          "${cfg.options.mediaLocation}/tv:/tv"
        ];
        ports = [
          "${port}:6767"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Bazarr";
          "homepage.icon" = "bazarr";
          "homepage.href" = "https://bazarr.${cfg.options.urlBase}";
          "homepage.description" = "Downloads and organizes subtitles";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`bazarr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "6767";
        } else {} );
      };
      containers.jellyfin = let
      	port = toString (cfg.uiPortStart + 800);
      in {
        hostname = "jellyfin";
        image = "lscr.io/linuxserver/jellyfin:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/jellyfin:/config"
          "${cfg.options.mediaLocation}/movies:/data/movies"
          "${cfg.options.mediaLocation}/tv:/data/tvshows"
        ];
        ports = [
          "${port}:8096"
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
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Jellyfin";
          "homepage.icon" = "jellyfin";
          "homepage.href" = "https://jellyfin.${cfg.options.urlBase}";
          "homepage.description" = "Stream your local media";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`jellyfin.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8096";
        } else {} );
      };
      containers.jellyseerr = let
      	port = toString (cfg.uiPortStart + 900);
      in {
        hostname = "jellyseerr";
        image = "fallenbagel/jellyseerr:${cfg.version}";
	
        volumes = [
          "${cfg.dataLocation}/jellyseerr:/config"
        ];
        ports = [
          "${port}:5055"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
	  LOG_LEVEL = "debug";
        };
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "Jellyseerr";
          "homepage.icon" = "jellyseerr";
          "homepage.href" = "https://jellyseerr.${cfg.options.urlBase}";
          "homepage.description" = "Controll the *arr stack";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`jellyseerr.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "5055";
        } else {} );
      };
      containers.bitmagnet = let
      	port = toString (cfg.uiPortStart + 1000);
      in {
        hostname = "bitmagnet";
        image = "ghcr.io/bitmagnet-io/bitmagnet:${cfg.version}";
	
        volumes = [
        ];
        ports = [
          "${port}:3333"
          "3334:3334/tcp"
          "3334:3334/udp"
        ];
	environment = {
	  PUID = "1000";
	  PGID = "100";
          TZ = "${cfg.timeZone}";
          POSTGRES_HOST = "postgres";
            POSTGRES_PASSWORD = "postgres";
        };
        cmd = [
            "worker"
            "run"
            "--keys=http_server"
            "--keys=queue_server"
        ];
        extraOptions = [
        ];
        labels =    (if cfg.enableHomePage == true then {
          "homepage.group" = "*arr";
          "homepage.name" = "bitmagnet";
          "homepage.icon" = "bitmagnet";
          "homepage.href" = "https://bitmagnet.${cfg.options.urlBase}";
          "homepage.description" = "Crawls dht for extra indexing options";
        } else {} ) //
        (if cfg.enableTraefik == true then {
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.rule" = "Host(`bitmagnet.${cfg.options.urlBase}`)";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.tls.certresolver" = "porkbun";
          "traefik.http.services.traefik.loadbalancer.server.port" = "3333";
        } else {} );
      };
      containers.postgres-bit = {
        hostname = "postgres-bit";
        image = "postgres:16-alpine";
        volumes = [
          "${cfg.dataLocation}/postgres:/var/lib/postgresql/data"
        ];
        ports = [
          "5432:5432"
        ];
	environment = {
       POSTGRES_PASSWORD = "postgres";
       POSTGRES_DB = "bitmagnet";
       PGUSER = "postgres";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.uiPortStart ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
      "d ${cfg.dataLocation}/downloads 0770 osmo users - -"
      "d ${cfg.dataLocation}/deluge 0770 osmo users - -"
      "d ${cfg.dataLocation}/qbittorrent 0770 osmo users - -"
      "d ${cfg.dataLocation}/prowlarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/sonarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/radarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/lidarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/readarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/bazarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyfin 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyseerr 0770 osmo users - -"
      "d ${cfg.dataLocation}/postgres 0770 osmo users - -"
    ];
  };
}
