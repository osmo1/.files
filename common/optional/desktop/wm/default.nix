{ lib, pkgs, ... }:
{
  imports = (lib.custom.scanPaths ./.);
  users.users.osmo.packages =
    (with pkgs.stable; [
      dconf
      kanshi
      blueman
      playerctl
      swayidle
      udiskie
      dwlb
      swaybg
      nautilus
      fuzzel
      swaylock
      networkmanagerapplet
    ])
    ++ (with pkgs.unstable; [ ]);

  programs = {
    light.enable = true;
  };
  security.pam.services.swaylock = { };
}
