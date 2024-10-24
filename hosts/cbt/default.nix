{
  config,
  lib,
  configLib,
  pkgs,
  nixvim,
  inputs,
  nur,
  ...
}:

{
  imports = (configLib.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cybersecurity.nix
  ];

  system.stateVersion = "24.05";

  networking.hostName = "cbt";

  users.users = {
    osmo.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeBjrcy3Gh5gfHlFVNmAVSb2iTamDdOW4PNXH1pU2bQ osmo@osmo.zip"
    ];
  };

  #TODO: Find a better place for this
  # common/optional/ssh.nix ?
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowPing = true;
}
