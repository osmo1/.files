{ config, ... }: {
    sops.secrets."nixos/password".neededForUsers = true;
    users = {
        mutableUsers = false;
    	users.osmo = {
        	isNormalUser = true;
        	initialPassword = "osmo";
		#hashedPasswordFile = config.sops.secrets."nixos/password".path;
        	extraGroups = [ "networkmanager" "wheel" ];
    	};
    };
}
