{ lib, ... }:
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    #../../common/optional/desktop/plasma
    ../../common/optional/desktop/dwl
    #../../common/optional/desktop/core
    ../../common/optional/desktop/optional/tuigreet.nix
    ../../common/optional/grub.nix
    ../../common/optional/gaming.nix
    #../../common/optional/syncthing.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/ssh.nix
    #../../common/optional/yubikey-boot.nix
    #../../common/optional/auto-login.nix
  ];

  hostSpec = {
    hostName = "lixos";
    isLaptop = true;
    style = "Classic";
    theme = "Tokyo Night";
    wallpaper = "stolen/plasma2k.png";
    sshKeys = [
      "masiina"
      "serveri"
      "klusteri-0"
      "klusteri-1"
      "klusteri-2"
    ];
  };
}
