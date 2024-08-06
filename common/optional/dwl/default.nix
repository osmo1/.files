{ configLib, pkgs, ... }:{
  imports = (configLib.scanPaths ./.)
  	++ [ ../sound.nix ];
 #home-manager.users.osmo = {}: {} 

        users.users.osmo.packages = with pkgs; [ /*dwl*/ (pkgs.dwl.override {
          # trying to supply config.home.homeDirectory here leads to "impure" usage.
          # so disabling it for now.
          # conf = (builtins.readFile "${config.home.homeDirectory}/.config/dwl/config.h");
          conf = ./config.h;
        })];
	security.polkit.enable = true;
	hardware.opengl = {
	  enable = true;
	  driSupport = true;
	};

}
