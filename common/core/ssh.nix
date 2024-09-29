{ config, configLib, configVars, lib, ... }: {

  home-manager.users.osmo = { inputs, pkgs, ... }: {
programs.ssh = {
    enable = true;

    # req'd for enabling yubikey-agent
    extraConfig = ''
      AddKeysToAgent yes
    '';

    matchBlocks = {
      "git" = {
        host = "github.com codeberg.org";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = [ "~/.ssh/git" ];
      };
    };
  };
};
  sops.secrets."nixos/${config.networking.hostName}/ssh/public" = {};
  system.activationScripts."${configVars.username}-authorizedKeys".text = ''
    mkdir -p "/etc/ssh/authorized_keys.d;
    cp "${config.sops.secrets."nixos/${config.networking.hostName}/ssh/public".path}" "/etc/ssh/authorized_keys.d/${configVars.username}";
    chmod +r "/etc/ssh/authorized_keys.d/${configVars.username};
  '';
  
      #environment = lib.mkIf config.fileSystems."/persist".neededForBoot {
	    environment.persistence."/persist".files = [
              "/etc/ssh/authorized_keys.d/${configVars.username}"
	    ];
	  #};
  sops.secrets = {
    "nixos/${config.networking.hostName}/git/private" = {
      path = "/home/${configVars.username}/.ssh/git";
      owner = "osmo";
      group = "users";
      mode = "600";
    };
  };
  security.pam.sshAgentAuth.enable = true;
}
