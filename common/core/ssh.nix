{
  config,
  configVars,
  ...
}:
{

  home-manager.users.osmo = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        # Default values
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        # Custom blocks
        "git" = {
          host = "github.com codeberg.org";
          user = "git";
          forwardAgent = true;
          identitiesOnly = true;
          identityFile = [ "~/.ssh/git" ];
        };
        "restic" = {
          host = "klusteri-2 192.168.11.12";
          user = "restic";
          forwardAgent = true;
          identitiesOnly = true;
          identityFile = [ "~/.ssh/restic" ];
        };
      };

      # req'd for enabling yubikey-agent
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
  };
  sops.secrets = {
    "nixos/${config.networking.hostName}/ssh/public" = {
      path = "/etc/ssh/authorized_keys.d/${configVars.username}";
      owner = "root";
      group = "root";
      mode = "644";
    };
    "nixos/${config.networking.hostName}/git/private" = {
      path = "/home/${configVars.username}/.ssh/git";
      owner = "osmo";
      group = "users";
      mode = "600";
    };
  };
  security.pam.sshAgentAuth.enable = true;
}
