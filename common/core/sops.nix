{
  config,
  lib,
  inputs,
  ...
}:
let
  secretsPath = builtins.toString inputs.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/persist/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      test = { };
    };
  };
  #environment = lib.mkIf config.fileSystems."/persist".neededForBoot {
  /*
    environment.persistence."/persist".directories = [
    	      "/var/lib/sops-nix"
    	    ];
    	  #};
  */

  # Annoyingly sops-nix and impermanence don't work well together, this is a workaround for now.
  /*systemd.services.decrypt-sops = {
    description = "Decrypt sops secrets";
    wantedBy = [ "multi-user.target" ];
#after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # in network is not ready
      Restart = "on-failure";
      RestartSec = "2s";
    };
    script = config.system.activationScripts.setupSecrets.text # + config.system.activationScripts.setupSecretsForUsers.text
    ;
  };*/

}
