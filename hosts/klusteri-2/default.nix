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
    ../../common/optional/restic.nix
    ../../common/optional/beszel.nix
  ];

  hostSpec = {
    hostName = "klusteri-2";
    isServer = true;
    ip = "192.168.11.12";
  };
}
