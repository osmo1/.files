{ inputs, ... }:
{
    imports = [
    	inputs.home-manager.nixosModules.home-manager
	../../common/optional/plasma/rc2nix.nix
    ];

    home-manager.users.osmo = { inputs, ... }: {
	imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
	home.stateVersion = "24.05";
    programs.plasma.enable = true;
    };
}
