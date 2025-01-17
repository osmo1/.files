{ lib, config, ... }:
with lib;
let
  cfg = config.services.containers.home-assistant;
in
{
  options.services.containers.home-assistant = {
    enable = mkEnableOption "Enable full text home-assistant and home-assistant sync services";
    version = mkOption {
      type = types.str;
      default = "latest";
    };
    uiPort = mkOption {
      type = types.port;
      default = 80;
    };
    dataLocation = mkOption {
      type = types.str;
      default = "${config.users.users.osmo.home}/home-assistant";
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
        default = "klusteri-0.kotiserweri.zip";
      };
    };
    options =
      {
      };
  };

  config = mkIf cfg.enable {

    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "eno2";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };

    containers.home-assistant = {
      autoStart = true;
      hostAddress = "192.168.11.11";
      localAddress = "192.168.11.21";
      privateNetwork = true;

      forwardPorts = [
        {
          containerPort = 8123;
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
      };

      config =
        { config, pkgs, ... }:
        {

          system.stateVersion = "24.11";

        services.home-assistant = {
            enable = true;
            extraComponents = [
              # Components required to complete the onboarding
              "esphome"
              "met"
              "radio_browser"
            ];
            config = {
              # Includes dependencies for a basic setup
              # https://www.home-assistant.io/integrations/default_config/
              default_config = {};
            };
          };

          networking = {
            firewall = {
              enable = true;
              allowedTCPPorts = [ 8123 ];
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
                    home-assistant:
                      rule: "Host(\`home-assistant.${cfg.traefik.urlBase}\`)"
                      entryPoints:
                        - websecure
                      tls:
                        certResolver: porkbun
                      service: home-assistant
                  services:
                    home-assistant:
                      loadBalancer:
                        servers:
                          - url: http://192.168.11.11:${builtins.toString cfg.uiPort}
              '';
            in
            config.lib.dag.entryAfter [ "writeBoundary" ] ''
              cat <<EOF > /home/osmo/traefik/config/home-assistant.yaml
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
