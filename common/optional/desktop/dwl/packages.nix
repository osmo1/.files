{ pkgs, ... }:
{
  users.users.osmo.packages = with pkgs; [
    foot
  ];
}
