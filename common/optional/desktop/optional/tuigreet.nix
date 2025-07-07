{ config, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.stable.greetd.tuigreet}/bin/tuigreet --time --cmd dbus-dwl";
        user = "${config.hostSpec.username}";
      };
    };
  };
}
