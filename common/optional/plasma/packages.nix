{ pkgs, pkgs-unstable, ... }:
{
        users.users.osmo.packages = with pkgs; [
            #kate
            wireguard-tools
	    (librewolf-wayland.override {  cfg.enablePlasmaBrowserIntegration = true; })
	    anki
	    bitwarden
	    thunderbird
	    whatsapp-for-linux
	    libsForQt5.dragon
	    capitaine-cursors
        ];
}
