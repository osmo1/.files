{ pkgs, ... }:
{
  users.users.osmo.packages = with pkgs; [
    minetest
    prismlauncher
  ];
  programs.steam = {
  enable = true;
	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
	  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

}
