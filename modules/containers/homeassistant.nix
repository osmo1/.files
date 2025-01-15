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
      default = "${config.users.users.osmo.home}/fresh";
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

    networking.firewall.allowedTCPPorts = [ cfg.home-assistantUiPort cfg.freshUiPort ];
    systemd.tmpfiles.rules = [
      "d ${cfg.dataLocation} 0770 osmo users - -"
    ];
  };
}
