{ config, secrets, inputs, ... }:
let
  secretsPath = builtins.toString inputs.secrets;
in
{
    sops.secrets.password = {
	neededForUsers = true;
	path = "/persist/run/secrets-for-users/password";
    };
    users = {
        mutableUsers = false;
    	users.osmo = {
        	isNormalUser = true;
        	#initialPassword = "osmo";
		# Sops (user secrets) does not want to work with impermanence so im (not) using git-agecrypt
		#hashedPasswordFile = "${secretsPath}/password";
		#hashedPasswordFile = config.sops.secrets.password.path;
        	extraGroups = [ "networkmanager" "wheel" ];
    	};
    };
      # No idea if this safe
 #     environment.persistence."/persist" = {
 #         directories = [ "/run/secrets-for-users"  ];
 #         files = [ "/run/secrets-for-users.d/age-keys.txt" ];
 #     };
 #   systemd.tmpfiles.rules = [
 #       "d /persist/run/secrets-for-users 0777 root root -"
 #   ];
}
