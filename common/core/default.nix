{
  inputs,
  outputs,
  lib,
  config,
  ...
}:
{
  imports =
    (lib.custom.scanPaths ./.)
    ++ [ inputs.home-manager.nixosModules.home-manager ]
    ++ [ ../../modules/nixos ];

  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    # Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=60 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep += SSH_AUTH_SOCK
  '';

  time.timeZone = lib.mkDefault "Europe/Helsinki";

  i18n.defaultLocale = lib.mkDefault "en_IE.UTF-8";

  environment.sessionVariables = {
    FLAKE = "/home/osmo/.files";
    EDITOR = "nvim";
  };

  console.keyMap = "fi";

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    hostName = config.hostSpec.hostName;
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  sops.secrets = builtins.listToAttrs (
    map (hostname: {
      name = "nixos/${hostname}/ssh/private";
      value = {
        path = "/home/osmo/.ssh/${hostname}";
        owner = "osmo";
        group = "users";
        mode = "600";
      };
    }) config.hostSpec.sshKeys
  );

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  system.stateVersion = "24.05";

  hostSpec = {
    username = "osmo";
    email = "osmo@osmo.zip";
    handle = "osmo1";
  };
}
