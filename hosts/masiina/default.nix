{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  ryzen-undervolt = pkgs.writeScriptBin "ryzen-undervolt" (
    builtins.readFile "${inputs.ryzen-undervolt}/ruv.py"
  );
in
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../../common/core
    ../../common/optional/cli
    ../../common/optional/desktop/gnome
    ../../common/optional/grub.nix
    ../../common/optional/plymouth.nix
    ../../common/optional/gaming.nix
    ../../common/optional/nvidia.nix
    # ../../common/optional/starcitizen.nix
    # ../../common/optional/auto-login.nix
    ../../common/optional/podman.nix
    ../../common/optional/syncthing.nix
    ../../common/optional/desktop/optional/virtmanager.nix
    ../../common/optional/desktop/optional/sunshine.nix
    ../../common/optional/desktop/optional/discord.nix
    ../../common/optional/dev/rust.nix
  ];

  hostSpec = {
    hostName = "masiina";

    sshKeys = [
      "lixos"
      "serveri"
      "klusteri-0"
      "klusteri-1"
      "klusteri-2"
      "oraakeli"
    ];

    style = "Classic";
    theme = "Kanagawa";
    wallpaper = "stolen/staircase.png";
  };

  services.hardware.openrgb.enable = true;

  restic = {
    enable = true;
    remote = true;
  };

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

  environment.systemPackages = [
    ryzen-undervolt
  ]
  ++ (with pkgs.stable; [
    swtpm
    # python312Full
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        requests
      ]
    ))
    looking-glass-client
    swtpm
    qalculate-qt
    mariadb
    fractal
    # cinny-desktop
    mesa
    libglvnd
    librewolf
    vivaldi
    # jellyfin-media-player
  ])
  ++ (with pkgs.unstable; [
  ])
  ++ [
    inputs.blender-cuda.packages.x86_64-linux.default

  ];

  systemd.services.ryzen-undervolt = {
    description = "Ryzen 5700x3D undervolting service";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.python312 ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.python312} ${lib.getExe ryzen-undervolt} -c 8 -o -15";
    };
  };
  hardware.cpu.amd = {
    updateMicrocode = true;
    ryzen-smu.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.NetworkManager.wantedBy = [ "multi-user.target" ];
  systemd.targets.network-online.wantedBy = lib.mkForce [ ];
  networking.firewall.enable = lib.mkForce false;

  # DB
  services.mysql = {
    enable = true;
    package = pkgs.stable.mariadb;
    # user = "osmo";
    # group = "users";
    # dataDir = "/home/osmo/misc/chatroom-rs/mysql";
    ensureUsers = [
      # {
      #   name = "osmo";
      #   ensurePermissions = {
      #     "*.*" = "ALL PRIVILEGES";
      #   };
      # }
    ];
    initialDatabases = [ { name = "chatroom"; } ];
    settings = {
      mysqld = {
        port = "6969";
        bind-address = "127.0.0.1";
      };
    };
  };
  hardware.graphics.enable = true;
}
