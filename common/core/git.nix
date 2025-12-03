{ config, ... }:
{
  home-manager.users.osmo = {
    programs.git = {
      enable = true;
      settings.user = {
        name = config.hostSpec.username;
        email = config.hostSpec.email.personal;
      };
    };
  };
}
