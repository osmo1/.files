{
  pkgs,
  inputs,
  lib,
  configLib,
  config,
  ...
}:
let
  hostnames = [
    "lixos"
    "testeri"
    "serveri"
    "klusteri-0"
    "klusteri-1"
    "klusteri-2"
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
    ../../common/optional/tpm.nix
    ../../common/optional/ssh.nix
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

  borgus.enable = true;

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
    # The services doesn't actually work atm, define an additional service
  # see https://github.com/NixOS/nixpkgs/issues/91352
  systemd.services.wakeonlan = {
    description = "Reenable wake on lan every boot";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      RemainAfterExit = "true";
      ExecStart = "${pkgs.ethtool}/sbin/ethtool -s enp5s0 wol g";
    };
    wantedBy = [ "default.target" ];
  };

  networking.hostName = "masiina";
    environment.systemPackages = [
      ryzen-undervolt
      pkgs.python312Full
    pkgs.looking-glass-client
    pkgs.swtpm
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

    boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    boot.kernelModules = [ "kvmfr" ];
    boot.extraModprobeConfig = ''
        options kvmfr static_size_mb=32
    '';
    services.udev.extraRules = ''
        SUBSYSTEM=="kvmfr", OWNER="osmo", GROUP="kvm", MODE="0660"
    '';
    virtualisation.libvirtd.qemu.verbatimConfig = ''
        cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm",
            "/dev/kvmfr0"
        ]
    '';
  /*systemd.services.NetworkManager = {
      wantedBy = lib.mkForce [ ];
      after = [ "graphical.target" ];
      wants = [ "graphical.target" ];
  };

    systemd.services.NetworkManager-dispatcher = {
        wantedBy = lib.mkForce [ ];
        after = [ "graphical.target" ];
      wants = [ "graphical.target" ];
    };
    systemd.targets.network-online = {
        after = lib.mkForce [ "graphical.target" ];
        wants = lib.mkForce  [ "graphical.target" ];
    };
    systemd.services.NetworkManager-wait-online = {
        wantedBy = lib.mkForce [ ];
        after = [ "graphical.target" ];
      wants = [ "graphical.target" ];
    };*/
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.NetworkManager.wantedBy = [ "multi-user.target" ];
    systemd.targets.network-online.wantedBy = lib.mkForce [ ];

}
