{
  config,
  lib,
  pkgs,
  nixvim,
  inputs,
  nur,
  configLib,
  ...
}:
{
  imports = (configLib.scanPaths ./.) ++ [
    ../../common/core
  ../../common/optional/cli
#../../common/optional/impermanence.nix
    ../../common/optional/systemd-boot.nix
    ../../common/optional/podman.nix
#../../common/optional/samba.nix
    ../../common/optional/nfs.nix
    ../../common/optional/ssh.nix
    ../../common/optional/nbde.nix
  ];

  system.stateVersion = "24.05";

  networking.hostName = "serveri";

  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowPing = true;
}
