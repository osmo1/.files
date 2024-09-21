{ pkgs, pkgs-unstable, ... }:
{
  users.users.osmo.packages = with pkgs; [
    wireguard-tools
    librewolf
    bitwarden
    thunderbird
    capitaine-cursors
  ];
}