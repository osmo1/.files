{
  inputs,
  outputs,
  lib,
  configLib,
  ...
}:
{
  imports = (configLib.scanPaths ./.) ++ [ inputs.home-manager.nixosModules.home-manager ];

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

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
}
