{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.services.containers.nextcloud;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  options.services.containers.nextcloud = {
    enable = mkEnableOption "Enable nextcloud with a web ui";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/data/nextcloud";
    };
    configLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/nextcloud/config";
    };
    uiPort = mkOption {
      type = types.port;
      default = 80;
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
      urlBase = mkOption {
        type = types.str;
        default = "serveri.kotiserweri.zip";
      };
    };
    options =
      {
      };
  };

  config = mkIf cfg.enable {
    sops.secrets."containers/password" = {
      owner = "dhcpcd";
      group = "dhcpcd";
      mode = "700";
    };
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp2s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };

    containers.nextcloud = {
      autoStart = true;
      hostAddress = "192.168.11.200";
      localAddress = "192.168.11.201";
      privateNetwork = true;

      forwardPorts = [
        {
          containerPort = 80;
          hostPort = cfg.uiPort;
          protocol = "tcp";
        }
      ];

      ephemeral = true;

      bindMounts = {
        "/data" = {
          hostPath = cfg.dataLocation;
          isReadOnly = false;
        };
        "/config" = {
          hostPath = "${cfg.configLocation}/config";
          isReadOnly = false;
        };
        "/secrets/password" = {
          hostPath = "/var/run/secrets/containers/password";
          isReadOnly = false;
        };
      };

      config =
        { config, pkgs, ... }:
        {

          system.stateVersion = "24.11";

          services = {
            nextcloud = {
              enable = true;
              package = pkgs.nextcloud30;

              home = "/config";
              datadir = "/data";

              hostName = "nextcloud.serveri.kotiserweri.zip";
              extraApps = {
                inherit (pkgs.nextcloud30Packages.apps) calendar;
                music = pkgs.fetchNextcloudApp {
                  sha256 = "sha256-yexffDYu0dv/i/V0Z+U1jD1+6X/JZuWZ4/mqWny5Nxs=";
                  url = "https://github.com/owncloud/music/releases/download/v2.0.1/music_2.0.1_for_nextcloud.tar.gz";
                  license = "gpl3";
                };
              };
              autoUpdateApps.enable = true;
              maxUploadSize = "32G";
              caching = {
                redis = true;
                apcu = true;
                memcached = true;
              };
              configureRedis = true;
              appstoreEnable = false;
              database.createLocally = true;
              settings = {
                trusted_domains = [ "nextcloud.serveri.kotiserweri.zip" ];
                trusted_proxies = [ "traefik.serveri.kotiserweri.zip" ];
                overwrite.cli.url = "https://nextcloud.${cfg.traefik.urlBase}";
                overwriteprotocol = "https";
              };
              config = {
                adminuser = "osmo";
                adminpassFile = "/secrets/password";
              };
            };
          };
          networking = {
            firewall = {
              enable = true;
              allowedTCPPorts = [ 80 ];
            };
            # Use systemd-resolved inside the container
            # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
            useHostResolvConf = lib.mkForce false;
          };
          services.resolved.enable = true;
        };
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 dhcpcd dhcpcd - -"
      "d ${cfg.configLocation} 0770 dhcpcd dhcpcd - -"
      "d ${cfg.configLocation}/config 0770 dhcpcd dhcpcd - -"
      "d ${cfg.configLocation}/secrets 0770 dhcpcd dhcpcd - -"
    ];
    networking.firewall.allowedTCPPorts = [ cfg.uiPort ];
    home-manager.users =
      let
        traefikConf =
      { config, lib, ... }:
        {
          home.activation.myActivationAction =
            let
              nconfig = ''
                http:
                  routers:
                    nextcloud:
                      rule: "Host(\`nextcloud.${cfg.traefik.urlBase}\`)"
                      entryPoints:
                        - websecure
                      tls:
                        certResolver: porkbun
                      service: nextcloud
                  services:
                    nextcloud:
                      loadBalancer:
                        servers:
                          - url: http://192.168.11.200:${builtins.toString cfg.uiPort}
              '';
            in
            config.lib.dag.entryAfter [ "writeBoundary" ] ''
              cat <<EOF > /home/osmo/traefik/config/nextcloud.yaml
              ${nconfig}
              EOF
            '';
        };
      in
      {
        osmo =
            lib.mkIf cfg.traefik.enable traefikConf;
      };
  };

}
