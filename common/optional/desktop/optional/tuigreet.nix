{ config, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.stable.tuigreet}/bin/tuigreet --time";
        user = "${config.hostSpec.username}";
      };
    };
  };
  security.pam.services.greetd.startSession = true;
}
