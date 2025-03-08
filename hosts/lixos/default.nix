{ lib, ... }:
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/desktop/plasma
    ../../common/optional/grub.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/ssh.nix
    ../../common/optional/yubikey-boot.nix
    ../../common/optional/auto-login.nix
  ];

  hostSpec = {
    hostName = "lixos";
    isLaptop = true;

    sshKeys = [
      "masiina"
      "serveri"
      "klusteri-0"
      "klusteri-1"
      "klusteri-2"
    ];
  };
}
