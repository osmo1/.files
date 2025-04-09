{ lib, pkgs, ... }:
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/school
  ];

  hostSpec = {
    hostName = "nix-wsl";

    sshKeys = [
      "testeri"
      "serveri"
      "klusteri-0"
      "klusteri-1"
      "klusteri-2"
    ];
  };

  wsl.enable = true;
  wsl.defaultUser = "osmo";
  wsl = {
    usbip = {
      enable = true;
      autoAttach = [ "1-2" ];
    };
  };

  services.udev = {
    enable = true;
    packages = [ pkgs.yubikey-personalization ];
    extraRules = ''
      SUBSYSTEM=="usb", MODE="0666"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0666"
    '';
  };
}
