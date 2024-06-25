
{
        users.users.osmo.packages = with pkgs; [
            kate
            wireguard-tools
	    (librewolf-wayland.override {  cfg.enablePlasmaBrowserIntegration = true; })
	    anki
	    bitwarden
        ];
}
