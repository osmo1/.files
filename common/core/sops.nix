{ config, lib, inputs, ... }:
let
  secretsPath = builtins.toString inputs.secrets;
in
{
	imports = [
		inputs.sops-nix.nixosModules.sops
	];

	sops = {
		defaultSopsFile = "${secretsPath}/secrets.yaml";
		validateSopsFiles = false;
		age = {
			sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			keyFile = "/var/lib/sops-nix/key.txt";
			generateKey = true;
		};
		secrets = {
			test = {};
			"syncthing/testeri/key" = {};
		};
	};
      environment.persistence."/persist" = {
	    directories = [
	      "/var/lib/sops-nix"
	    ];
	    files = [
	    ];
	  };

  # Annoyingly sops-nix and impermanence don't work well together, this is a workaround for now.
  systemd.services.decrypt-sops = {
    description = "Decrypt sops secrets";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # in network is not ready
      Restart = "on-failure";
      RestartSec = "2s";
    };
    script = config.system.activationScripts.setupSecrets.text;
   };

}
