{ pkgs, ... }:
{
  users.users.osmo.packages =
    (with pkgs.stable; [
      minetest
      heroic
      prismlauncher
    ])
    ++ (
      with pkgs.unstable;
      [
      ]
    );
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

}
