{ lib, ... }:
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/systemd-boot.nix
    ../../common/optional/podman.nix
    ../../common/optional/samba.nix
    ../../common/optional/nfs.nix
    ../../common/optional/ssh.nix
    ../../common/optional/nbde.nix
  ];

  hostSpec = {
    hostName = "serveri";
    isServer = true;
  };
  restic = {
    enable = true;
    extraExcludes = [
      "/home/osmo/tmp"
      "/home/osmo/data/nfs"
    ];
  };
}
