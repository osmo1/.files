{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.containers.wireguard;
in
{
  options.services.containers.wireguard = {
    enable = mkEnableOption "Enable wireguard with a web ui";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/wireguard";
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
        default = "klusteri-0.serweri.zip";
      };
    };
    options = {
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers = {
      containers.wireguard = {
        hostname = "wireguard";
        image = "ghcr.io/wg-easy/wg-easy:${cfg.version}";
        volumes = [
          "${cfg.dataLocation}:/etc/wireguard"
          #"/lib/modules:/lib/modules:ro"
        ];
        ports = [
          "${toString cfg.uiPort}:51821"
          "51820:51820/udp"
        ];
        environment = {
          #TZ = "${cfg.timeZone}";
        };
        extraOptions = [
          "--sysctl=net.ipv4.ip_forward=1"
          "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
          "--sysctl=net.ipv6.conf.all.disable_ipv6=0"
          "--sysctl=net.ipv6.conf.all.forwarding=1"
          "--sysctl=net.ipv6.conf.default.forwarding=1"
          "--cap-add=NET_ADMIN"
          "--cap-add=SYS_MODULE"
          "--cap-add=NET_RAW"
          "--ip6=fdcc:ad94:bacf:61a3::2a"
          "--ip=10.42.42.42"
        ];
        networks = [ "wireguard_wg" ];
        labels =
          (
            if cfg.enableHomePage == true then
              {
                "homepage.group" = "Network";
                "homepage.name" = "Wireguad";
                "homepage.icon" = "wireguard";
                "homepage.href" = "https://wireguard.${cfg.traefik.urlBase}";
                "homepage.description" = "Local vpn service";
              }
            else
              { }
          )
          // (
            if cfg.traefik.enable == true then
              {
                "traefik.enable" = "true";
                "traefik.http.routers.wireguard.rule" = "Host(`wireguard.${cfg.traefik.urlBase}`)";
                "traefik.http.routers.wireguard.entrypoints" = "websecure";
                "traefik.http.routers.wireguard.tls.certresolver" = "porkbun";
                "traefik.http.services.wireguard.loadbalancer.server.port" = "51821";
              }
            else
              { }
          );
      };
    };
    systemd.services."podman-network-wireguard_wg" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f wireguard_wg";
      };
      script = ''
        podman network inspect wireguard_wg || podman network create wireguard_wg --driver=bridge --subnet=10.42.42.0/24 --subnet=fdcc:ad94:bacf:61a3::/64 --ipv6
      '';
      partOf = [ "default.target" ];
      wantedBy = [ "default.target" ];
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.uiPort ];
      allowedUDPPorts = [ 51820 ];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
    networking = {
      nat = {
        enable = true;
      };
    };
    environment.systemPackages = [ pkgs.wireguard-tools ];
    boot = {
      kernelModules = [
        "nft_masq"
        "wireguard"
      ];
    };
  };
}
