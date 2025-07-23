{
  lib,
  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/podman.nix
    ../../common/optional/ssh.nix
    ../../common/optional/systemd-boot.nix
  ];

  system.stateVersion = "24.05";

  hostSpec = {
    hostName = "oraakeli";
    isServer = true;
  };
}
