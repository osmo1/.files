{
  config,
  configVars,
  ...
}:
{

  home-manager.users.osmo = {
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
        "restic" = {
          host = "klusteri-2 192.168.11.12";
          user = "restic";
          forwardAgent = true;
          identitiesOnly = true;
          identityFile = [ "~/.ssh/restic" ];
        };
        # "klusteri-1" = {
        #   host = "klusteri-1 192.168.11.11";
        #   user = "osmo";
        #   forwardAgent = true;
        #   identitiesOnly = true;
        #   identityFile = [ "~/.ssh/klusteri-1" ];
        # };
      };
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
