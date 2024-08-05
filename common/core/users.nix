{
    
    users = {
        mutableUsers = false;
    	users.osmo = {
        	isNormalUser = true;
        	initialPassword = "osmo";
        	extraGroups = [ "networkmanager" "wheel" ];
    	};
    };
}
