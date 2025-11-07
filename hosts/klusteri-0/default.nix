{ lib, ... }:
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/podman.nix
    ../../common/optional/tpm.nix
    ../../common/optional/ssh.nix
    ../../common/optional/nfs-mount.nix
    ../../common/optional/systemd-boot.nix
    ../../common/optional/syncthing.nix
    ../../common/optional/beszel.nix
  ];

  hostSpec = {
    hostName = "klusteri-0";
    isServer = true;
  };

  restic = {
    enable = true;
    remote = true;
    extraExcludes = [
      "/home/osmo/tmp"
      "/home/osmo/vanha"
    ];
  };
}
