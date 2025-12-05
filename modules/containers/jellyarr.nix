{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.containers.jellyarr;
in
{
  options.services.containers.jellyarr = {
    enable = mkEnableOption "Enable jellyfin, *arr services and deluge";
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
    version = {
      qbittorrent = mkOption {
        type = types.str;
        default = "latest";
      };
      prowlarr = mkOption {
        type = types.str;
        default = "latest";
      };
      flaresolverr = mkOption {
        type = types.str;
        default = "latest";
      };
      sonarr = mkOption {
        type = types.str;
        default = "latest";
      };
      radarr = mkOption {
        type = types.str;
        default = "latest";
      };
      lidarr = mkOption {
        type = types.str;
        default = "latest";
      };
      bazarr = mkOption {
        type = types.str;
        default = "latest";
      };
      jellyfin = mkOption {
        type = types.str;
        default = "latest";
      };
      jellyseerr = mkOption {
        type = types.str;
        default = "latest";
      };
      bitmagnet = mkOption {
        type = types.str;
        default = "latest";
      };
      postgres = mkOption {
        type = types.str;
        default = "latest";
      };
      booklore = mkOption {
        type = types.str;
        default = "latest";
      };
      gluetun = mkOption {
        type = types.str;
        default = "latest";
      };
      autobrr = mkOption {
        type = types.str;
        default = "latest";
      };
      cross-seed = mkOption {
        type = types.str;
        default = "latest";
      };
      profilarr = mkOption {
        type = types.str;
        default = "latest";
      };
      ephemera = mkOption {
        type = types.str;
        default = "latest";
      };
    };
    options = {
      urlBase = mkOption {
        type = types.str;
        default = "klusteri-1.serweri.zip";
      };
      mediaLocation = mkOption {
        type = types.str;
        default = "/mnt/media";
      };
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.qbittorrent =
        let
          port = toString cfg.uiPortStart;
        in
        {
          hostname = "qbittorrent";
          image = "lscr.io/linuxserver/qbittorrent:${cfg.version.qbittorrent}";

          volumes = [
            "${cfg.dataLocation}/qbittorrent:/config"
            "${cfg.options.mediaLocation}/downloads:/downloads"
            "${cfg.options.mediaLocation}/links:/links"
          ];
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "${cfg.timeZone}";
            WEBUI_PORT = "8080";
            TORRENTING_PORT = "6881";
          };
          extraOptions = [
            "--network=container:gluetun"
          ];
          dependsOn = [ "gluetun" ];

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Qbittorrent";
                  "homepage.icon" = "qbittorrent.png";
                  "homepage.href" = "https://deluge.${cfg.options.urlBase}";
                  "homepage.description" = "Torrent client";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.qbittorrent.rule" = "Host(`qbittorrent.${cfg.options.urlBase}`)";
                  "traefik.http.routers.qbittorrent.entrypoints" = "websecure";
                  "traefik.http.routers.qbittorrent.tls.certresolver" = "porkbun";
                  "traefik.http.services.qbittorrent.loadbalancer.server.port" = "8080";
                }
              else
                { }
            );
        };
      containers.prowlarr =
        let
          port = toString (cfg.uiPortStart + 100);
        in
        {
          hostname = "prowlarr";
          image = "lscr.io/linuxserver/prowlarr:${cfg.version.prowlarr}";

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

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Prowlarr";
                  "homepage.icon" = "prowlarr";
                  "homepage.href" = "https://prowlarr.${cfg.options.urlBase}";
                  "homepage.description" = "Indexer distributor";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.prowlarr.rule" = "Host(`prowlarr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.prowlarr.entrypoints" = "websecure";
                  "traefik.http.routers.prowlarr.tls.certresolver" = "porkbun";
                  "traefik.http.services.prowlarr.loadbalancer.server.port" = "9696";
                }
              else
                { }
            );
        };
      containers.flaresolverr =
        let
          port = toString (cfg.uiPortStart + 200);
        in
        {
          hostname = "flaresolverr";
          image = "21hsmw/flaresolverr:${cfg.version.flaresolverr}";

          ports = [
            "${port}:8191"
          ];
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "${cfg.timeZone}";
          };
        };
      containers.sonarr =
        let
          port = toString (cfg.uiPortStart + 300);
        in
        {
          hostname = "sonarr";
          image = "lscr.io/linuxserver/sonarr:${cfg.version.sonarr}";

          volumes = [
            "${cfg.dataLocation}/sonarr:/config"
            "${cfg.options.mediaLocation}:/media"
          ];
          ports = [
            "${port}:8989"
          ];
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "${cfg.timeZone}";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Sonarr";
                  "homepage.icon" = "sonarr";
                  "homepage.href" = "https://sonarr.${cfg.options.urlBase}";
                  "homepage.description" = "Downloads and organizes TV shows";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.sonarr.rule" = "Host(`sonarr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.sonarr.entrypoints" = "websecure";
                  "traefik.http.routers.sonarr.tls.certresolver" = "porkbun";
                  "traefik.http.services.sonarr.loadbalancer.server.port" = "8989";
                }
              else
                { }
            );
        };
      containers.radarr =
        let
          port = toString (cfg.uiPortStart + 400);
        in
        {
          hostname = "radarr";
          image = "lscr.io/linuxserver/radarr:${cfg.version.radarr}";

          volumes = [
            "${cfg.dataLocation}/radarr:/config"
            "${cfg.options.mediaLocation}:/media"
          ];
          ports = [
            "${port}:7878"
          ];
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "${cfg.timeZone}";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Radarr";
                  "homepage.icon" = "radarr";
                  "homepage.href" = "https://radarr.${cfg.options.urlBase}";
                  "homepage.description" = "Downlads and organizes movies";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.radarr.rule" = "Host(`radarr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.radarr.entrypoints" = "websecure";
                  "traefik.http.routers.radarr.tls.certresolver" = "porkbun";
                  "traefik.http.services.radarr.loadbalancer.server.port" = "7878";
                }
              else
                { }
            );
        };
      containers.lidarr =
        let
          port = toString (cfg.uiPortStart + 500);
        in
        {
          hostname = "lidarr";
          image = "lscr.io/linuxserver/lidarr:${cfg.version.lidarr}";

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

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "lidarr";
                  "homepage.icon" = "lidarr";
                  "homepage.href" = "https://lidarr.${cfg.options.urlBase}";
                  "homepage.description" = "Downloads and organizes music";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.lidarr.rule" = "Host(`lidarr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.lidarr.entrypoints" = "websecure";
                  "traefik.http.routers.lidarr.tls.certresolver" = "porkbun";
                  "traefik.http.services.lidarr.loadbalancer.server.port" = "8686";
                }
              else
                { }
            );
        };
      containers.bazarr =
        let
          port = toString (cfg.uiPortStart + 700);
        in
        {
          hostname = "bazarr";
          image = "lscr.io/linuxserver/bazarr:${cfg.version.bazarr}";

          volumes = [
            "${cfg.dataLocation}/bazarr:/config"
            "${cfg.options.mediaLocation}/movies:/media/movies"
            "${cfg.options.mediaLocation}/tv:/media/tv"
            "${cfg.options.mediaLocation}/own:/media/own"
          ];
          ports = [
            "${port}:6767"
          ];
          environment = {
            PUID = "1000";
            PGID = "100";
            TZ = "${cfg.timeZone}";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Bazarr";
                  "homepage.icon" = "bazarr";
                  "homepage.href" = "https://bazarr.${cfg.options.urlBase}";
                  "homepage.description" = "Downloads and organizes subtitles";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.bazarr.rule" = "Host(`bazarr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.bazarr.entrypoints" = "websecure";
                  "traefik.http.routers.bazarr.tls.certresolver" = "porkbun";
                  "traefik.http.services.bazarr.loadbalancer.server.port" = "6767";
                }
              else
                { }
            );
        };
      containers.jellyfin =
        let
          port = toString (cfg.uiPortStart + 800);
        in
        {
          hostname = "jellyfin";
          image = "jellyfin/jellyfin:${cfg.version.jellyfin}";

          volumes = [
            "${cfg.dataLocation}/jellyfin/config:/config"
            "${cfg.dataLocation}/jellyfin/cache:/cache"
            "${cfg.options.mediaLocation}/movies:/data/movies"
            "${cfg.options.mediaLocation}/tv:/data/tvshows"
            "${cfg.options.mediaLocation}/own:/data/own"
          ];
          ports = [
            "${port}:8096"
            "7359:7359/udp"
            "1900:1900"
          ];
          environment = {
            JELLYFIN_FFMPEG_EXTRA_ARGUMENTS = "-c:v hevc_qsv";
          };
          extraOptions = [
            "--group-add=303"
            "--device=/dev/dri/renderD128:/dev/dri/renderD128"
          ];

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Jellyfin";
                  "homepage.icon" = "jellyfin";
                  "homepage.href" = "https://jellyfin.${cfg.options.urlBase}";
                  "homepage.description" = "Stream your local media";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin.${cfg.options.urlBase}`)";
                  "traefik.http.routers.jellyfin.entrypoints" = "websecure";
                  "traefik.http.routers.jellyfin.tls.certresolver" = "porkbun";
                  "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
                }
              else
                { }
            );
        };
      containers.jellyseerr =
        let
          port = toString (cfg.uiPortStart + 900);
        in
        {
          hostname = "jellyseerr";
          image = "ghcr.io/fallenbagel/jellyseerr:${cfg.version.jellyseerr}";

          volumes = [
            "${cfg.dataLocation}/jellyseerr:/app/config"
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

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Jellyseerr";
                  "homepage.icon" = "jellyseerr";
                  "homepage.href" = "https://jellyseerr.${cfg.options.urlBase}";
                  "homepage.description" = "Controll the *arr stack";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.jellyseerr.rule" = "Host(`jellyseerr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.jellyseerr.entrypoints" = "websecure";
                  "traefik.http.routers.jellyseerr.tls.certresolver" = "porkbun";
                  "traefik.http.services.jellyseerr.loadbalancer.server.port" = "5055";
                }
              else
                { }
            );
        };
      containers.bitmagnet =
        let
          port = toString (cfg.uiPortStart + 1000);
        in
        {
          hostname = "bitmagnet";
          image = "ghcr.io/bitmagnet-io/bitmagnet:${cfg.version.bitmagnet}";

          ports = [
            "${port}:3333"
            "3334:3334/tcp"
            "3334:3334/udp"
          ];
          environment = {
            # Ok, I should really figure this out
            POSTGRES_HOST = "postgres-bit"; # I can't figure out why local hostnames don't work even thought they are on the same network (default because nixos doesnt allow declarative networks)
            POSTGRES_PASSWORD = "postgres";
          };
          cmd = [
            "worker"
            "run"
            "--keys=http_server"
            "--keys=queue_server"
            "--keys=dht_crawler"
          ];
          extraOptions = [
            "--network=container:gluetun"
          ];
          dependsOn = [ "gluetun" ];

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "bitmagnet";
                  "homepage.icon" = "bitmagnet";
                  "homepage.href" = "https://bitmagnet.${cfg.options.urlBase}";
                  "homepage.description" = "Crawls dht for extra indexing options";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.bitmagnet.rule" = "Host(`bitmagnet.${cfg.options.urlBase}`)";
                  "traefik.http.routers.bitmagnet.entrypoints" = "websecure";
                  "traefik.http.routers.bitmagnet.tls.certresolver" = "porkbun";
                  "traefik.http.services.bitmagnet.loadbalancer.server.port" = "3333";
                }
              else
                { }
            );
        };
      containers.postgres-bit = {
        hostname = "postgres-bit";
        image = "postgres:${cfg.version.postgres}";

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
        extraOptions = [
          "--network=container:gluetun"
          # "--network-alias=postgres-bit"
        ];
        dependsOn = [ "gluetun" ];
      };
      containers.booklore =
        let
          port = toString (cfg.uiPortStart + 1100);
        in
        {
          hostname = "booklore";
          image = "ghcr.io/booklore-app/booklore:${cfg.version.booklore}";
          # user = "1000:100";

          volumes = [
            "${cfg.dataLocation}/booklore/config:/app/data"
            "${cfg.options.mediaLocation}/books/sorted:/books"
            "${cfg.options.mediaLocation}/books/raw:/bookdrop"
          ];
          ports = [
            "${port}:6060"
          ];
          environment = {
            PUID = "1000";
            PGID = "100";
            "TZ" = cfg.timeZone;
            "DATABASE_URL" = "jdbc:mariadb://mariadb:3306/booklore";
            "DATABASE_USERNAME" = "booklore";
            "DATABASE_PASSWORD" = "your_secure_password";
            "BOOKLORE_PORT" = "6060";
            "SWAGGER_ENABLED" = "false";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "booklore";
                  "homepage.icon" = "booklore";
                  "homepage.href" = "https://booklore.${cfg.options.urlBase}";
                  "homepage.description" = "ODPS server for ebooks";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.booklore.rule" = "Host(`booklore.${cfg.options.urlBase}`)";
                  "traefik.http.routers.booklore.entrypoints" = "websecure";
                  "traefik.http.routers.booklore.tls.certresolver" = "porkbun";
                  "traefik.http.services.booklore.loadbalancer.server.port" = "6060";
                }
              else
                { }
            );
        };
      containers.mariadb = {
        hostname = "mariadb";
        image = "lscr.io/linuxserver/mariadb:11.4.5";

        volumes = [
          "${cfg.dataLocation}/mariadb:/config"
        ];
        ports = [
          "5432:5432"
        ];
        environment = {
          "PUID" = "1000";
          "PGID" = "100";
          "TZ" = cfg.timeZone;
          "MYSQL_ROOT_PASSWORD" = "super_secure_password";
          "MYSQL_DATABASE" = "booklore";
          "MYSQL_USER" = "booklore";
          "MYSQL_PASSWORD" = "your_secure_password";
        };
        extraOptions = [
          "--network-alias=mariadb"
        ];
      };
      containers.gluetun = {
        hostname = "gluetun";
        image = "qmcgaw/gluetun:${cfg.version.gluetun}";

        volumes = [
          "${cfg.dataLocation}/gluetun:/gluetun"
          "${cfg.dataLocation}/oraakeli.conf:/gluetun/wireguard/wg0.conf"
        ];
        ports = [
          "8388:8388/tcp"
          "8388:8388/udp"
          "1080:8080"
          "6881:6881"
          "6881:6881/udp"
        ];
        environment = {
          VPN_SERVICE_PROVIDER = "custom";
          VPN_TYPE = "wireguard";
        };
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun:/dev/net/tun:rwm"
        ];
      };
      containers.autobrr =
        let
          port = toString (cfg.uiPortStart + 1200);
        in
        {
          hostname = "autobrr";
          image = "ghcr.io/autobrr/autobrr:${cfg.version.autobrr}";

          volumes = [
            "${cfg.dataLocation}/autobrr:/config"
          ];
          ports = [
            "${port}:7474"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "autobrr";
                  "homepage.icon" = "autobrr";
                  "homepage.href" = "https://autobrr.${cfg.options.urlBase}";
                  "homepage.description" = "Fetches new releases from irc";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.autobrr.rule" = "Host(`autobrr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.autobrr.entrypoints" = "websecure";
                  "traefik.http.routers.autobrr.tls.certresolver" = "porkbun";
                  "traefik.http.services.autobrr.loadbalancer.server.port" = "7474";
                }
              else
                { }
            );
        };
      containers.cross-seed =
        let
          port = toString (cfg.uiPortStart + 1300);
        in
        {
          hostname = "cross-seed";
          image = "ghcr.io/cross-seed/cross-seed:${cfg.version.cross-seed}";

          user = "1000:100";
          volumes = [
            "${cfg.dataLocation}/cross-seed/config:/config"
            "${cfg.dataLocation}/cross-seed/output:/cross-seeds"
            "${cfg.dataLocation}/qbittorrent/qBittorrent/BT_backup:/torrents:ro"
            "${cfg.options.mediaLocation}/downloads:/downloads"
            "${cfg.options.mediaLocation}/links:/links"
          ];
          ports = [
            "${port}:2468"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
          };
          cmd = [
            "daemon"
          ];

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Cross-seed";
                  "homepage.icon" = "cross-seed";
                  "homepage.href" = "https://cross-seed.${cfg.options.urlBase}";
                  "homepage.description" = "Cross seeds torrents across private trackers";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.cross-seed.rule" = "Host(`cross-seed.${cfg.options.urlBase}`)";
                  "traefik.http.routers.cross-seed.entrypoints" = "websecure";
                  "traefik.http.routers.cross-seed.tls.certresolver" = "porkbun";
                  "traefik.http.services.cross-seed.loadbalancer.server.port" = "2468";
                }
              else
                { }
            );
        };
      containers.profilarr =
        let
          port = toString (cfg.uiPortStart + 1400);
        in
        {
          hostname = "profilarr";
          image = "santiagosayshey/profilarr:${cfg.version.profilarr}";

          # user = "1000:100";
          volumes = [
            "${cfg.dataLocation}/profilarr:/config"
          ];
          ports = [
            "${port}:6868"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "profilarr";
                  "homepage.icon" = "profilarr";
                  "homepage.href" = "https://profilarr.${cfg.options.urlBase}";
                  "homepage.description" = "Automatically set profiles for radarr and sonarr";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.profilarr.rule" = "Host(`profilarr.${cfg.options.urlBase}`)";
                  "traefik.http.routers.profilarr.entrypoints" = "websecure";
                  "traefik.http.routers.profilarr.tls.certresolver" = "porkbun";
                  "traefik.http.services.profilarr.loadbalancer.server.port" = "6868";
                }
              else
                { }
            );
        };
      containers.ephemera =
        let
          port = toString (cfg.uiPortStart + 1500);
        in
        {
          hostname = "ephemera";
          image = "ghcr.io/orwellianepilogue/ephemera:${cfg.version.ephemera}";

          # I need to setup rootless
          # user = "1000:100";
          volumes = [
            "${cfg.dataLocation}/ephemera/data:/app/data"
            "${cfg.dataLocation}/ephemera/downloads:/app/downloads"
          ];
          ports = [
            "${port}:8286"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
            AA_BASE_URL = "https://annas-archive.se";
            FLARESOLVERR_URL = "http://flaresolverr:1280";
            LG_BASE_URL = "https://libgen.li";
            # PUID = "1000";
            # PGID = "100";
          };

          labels =
            (
              if cfg.enableHomePage == true then
                {
                  "homepage.group" = "*arr";
                  "homepage.name" = "Ephemera";
                  "homepage.icon" = "ephemera";
                  "homepage.href" = "https://ephemera.${cfg.options.urlBase}";
                  "homepage.description" = "Book archive downloader";
                }
              else
                { }
            )
            // (
              if cfg.enableTraefik == true then
                {
                  "traefik.enable" = "true";
                  "traefik.http.routers.ephemera.rule" = "Host(`ephemera.${cfg.options.urlBase}`)";
                  "traefik.http.routers.ephemera.entrypoints" = "websecure";
                  "traefik.http.routers.ephemera.tls.certresolver" = "porkbun";
                  "traefik.http.services.ephemera.loadbalancer.server.port" = "8286";
                }
              else
                { }
            );
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
      "d ${cfg.dataLocation}/bazarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyfin 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyfin/cache 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyfin/config 0770 osmo users - -"
      "d ${cfg.dataLocation}/jellyseerr 0770 osmo users - -"
      "d ${cfg.dataLocation}/postgres 0770 osmo users - -"
      "d ${cfg.dataLocation}/booklore 0770 osmo users - -"
      "d ${cfg.dataLocation}/booklore/config 0770 osmo users - -"
      "d ${cfg.dataLocation}/booklore/data 0770 osmo users - -"
      "d ${cfg.dataLocation}/gluetun 0770 osmo users - -"
      "d ${cfg.dataLocation}/autobrr 0770 osmo users - -"
      "d ${cfg.dataLocation}/cross-seed 0770 osmo users - -"
      "d ${cfg.dataLocation}/cross-seed/config 0770 osmo users - -"
      "d ${cfg.dataLocation}/cross-seed/output 0770 osmo users - -"
      "d ${cfg.dataLocation}/mariadb 0770 osmo users - -"
      "d ${cfg.dataLocation}/profilarr 0770 osmo users - -"
      "d ${cfg.dataLocation}/ephemera 0770 osmo users - -"
      "d ${cfg.dataLocation}/ephemera/data 0770 osmo users - -"
      "d ${cfg.dataLocation}/ephemera/downloads 0770 osmo users - -"
    ];
    #services.resolved.enable = true;
  };
}
