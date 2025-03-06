{
  
  ...
}:

{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/xfce
    ../../common/optional/cybersecurity.nix
  ];

  system.stateVersion = "24.05";

  networking.hostName = "cbt";
  boot.loader.systemd-boot.enable = true;
}
