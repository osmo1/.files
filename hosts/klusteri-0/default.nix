{
  
  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/podman.nix
    ../../common/optional/tpm.nix
    ../../common/optional/ssh.nix
    ../../common/optional/nfs-mount.nix
    ../../common/optional/systemd-boot.nix
  ];

  system.stateVersion = "24.05";

  networking.hostName = "klusteri-0";
}
