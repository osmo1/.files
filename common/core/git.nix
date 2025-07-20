{ config, ... }:
{
  home-manager.users.osmo = {
    programs.git = {
      enable = true;
      userName = config.hostSpec.username;
      userEmail = config.hostSpec.email.personal;
    };
  };
}
