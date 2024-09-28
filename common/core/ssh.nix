{ config, configLib, configVars, lib, ... }: {
sops.secrets."nixos/${config.networking.hostName}" = {};

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
    users.users.osmo.openssh.authorizedKeys.keyFiles = [ (configLib.relativeToRoot ".secrets/${config.networking.hostName}/ssh.pub") ];
  sops.secrets = {
    "nixos/${config.networking.hostName}/ssh/public".path = "/run/secrets/nixos/${config.networking.hostName}/ssh/public";
    "nixos/${config.networking.hostName}/git/private".path = "/home/${configVars.username}/.ssh/git";
  };
}
