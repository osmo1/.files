{ pkgs, lib, ... }:
{
  home-manager.users.osmo = {
    programs.rofi = {
      enable = true;
      package = pkgs.stable.rofi;
    };
  };
}
