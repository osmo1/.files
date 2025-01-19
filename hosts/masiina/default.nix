{
  pkgs,
  inputs,
  lib,
  configLib,
  ...
}:
let
  hostnames = [
    "borgus"
    "lixos"
    "testeri"
    "serveri"
    "klusteri-0"
    "klusteri-1"
  ]; # Add your hostnames here
  ryzen-undervolt = pkgs.writeScriptBin "ryzen-undervolt" (
    builtins.readFile "${inputs.ryzen-undervolt}/ruv.py"
  );
in
{
  imports = (configLib.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    #../../common/optional/vpn.nix
    ../../common/optional/plasma
    ../../common/optional/grub.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/gaming.nix
    ../../common/optional/nvidia.nix
    ../../common/optional/starcitizen.nix
    ../../common/optional/auto-login.nix
    ../../common/optional/podman.nix
  ];

  system.stateVersion = "24.05";

  sops.secrets = builtins.listToAttrs (
    map (hostname: {
      name = "nixos/${hostname}/ssh/private";
      value = {
        path = "/home/osmo/.ssh/${hostname}";
        owner = "osmo";
        group = "users";
        mode = "600";
      };
    }) hostnames
  );
  networking.interfaces.enp5s0.wakeOnLan.enable = true;

  networking.hostName = "masiina";
    environment.systemPackages = [
      ryzen-undervolt
      pkgs.python312Full
    ];
    systemd.services.ryzen-undervolt = {
      description = "Ryzen 5700x3D undervolting service";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.python312Full ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.python312Full} ${lib.getExe ryzen-undervolt} -c 8 -o -15";
      };
    };
    hardware.cpu.amd = {
      updateMicrocode = true;
      ryzen-smu.enable = true;
    };
}
