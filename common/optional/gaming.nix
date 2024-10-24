{ pkgs, ... }:
{
  users.users.osmo.packages = with pkgs; [
    steam
    minetest
    prismlauncher
  ];
}
