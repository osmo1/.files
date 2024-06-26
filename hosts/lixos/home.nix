{ inputs, plasma-manager, ... }:
{
    imports = [
    	inputs.home-manager.nixosModules.home-manager
    	plasma-manager.homeManagerModules.plasma-manager
    ];
    home-manager.users.osmo = {
	home.stateVersion = "24.05";
    };
    programs.plasma.enable = true;
}
