{
  lib,
  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/podman.nix
    ../../common/optional/tpm.nix
    ../../common/optional/ssh.nix
    ../../common/optional/systemd-boot.nix
  ];

  system.stateVersion = "24.05";

  hostSpec = {
    hostName = "klusteri-2";
    isServer = true;
  };
}
