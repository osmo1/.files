{ pkgs, unstable-pkgs, ... }:
{
  users.users.osmo.packages = with pkgs; [
    wireguard-tools
    floorp
    bitwarden
    thunderbird
    capitaine-cursors
    alacritty
  ];
}
