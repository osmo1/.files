{ pkgs, ... }:{
 #home-manager.users.osmo = {}: {} 

        users.users.osmo.packages = with pkgs; [ dwl ];
	security.polkit.enable = true;
	hardware.opengl = {
	  enable = true;
	  driSupport = true;
	};

}
