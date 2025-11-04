{
  lib,
  pkgs,
  config,
  ...
}:
let
  hostname = config.hostSpec.hostName;
in
{
  systemd.user.services."beszel-agent" = {
    # systemd.services."beszel-agent" = {
    description = "Beszel Agent Service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.unstable.beszel "beszel-agent"}";
      Environment = [
        "LISTEN=45876"
        "KEY=\"${
          if hostname == "klusteri-0" then
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiaMAO8HC+3WoA2JV6gvLyBf++9DGpDPOv4pbxODzq9"
          else if hostname == "klusteri-1" then
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiaMAO8HC+3WoA2JV6gvLyBf++9DGpDPOv4pbxODzq9"
          else if hostname == "klusteri-2" then
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiaMAO8HC+3WoA2JV6gvLyBf++9DGpDPOv4pbxODzq9"
          else if hostname == "serveri" then
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILiaMAO8HC+3WoA2JV6gvLyBf++9DGpDPOv4pbxODzq9"
          else
            ""
        }\""
        "LOG_LEVEL=debug"
      ]
      ++ (if hostname == "serveri" then [ "EXTRA_FILESYSTEMS=/dev/dm-1" ] else [ ]);
      Restart = "on-failure";
      RestartSec = 5;
      StateDirectory = "beszel-agent";

      AmbientCapabilities = [
        "CAP_SYS_RAWIO"
        "CAP_SYS_ADMIN"
      ];
      CapabilityBoundingSet = [
        "CAP_SYS_RAWIO"
        "CAP_SYS_ADMIN"
      ];
      DeviceAllow = [
      ]
      ++ (
        if hostname == "klusteri-0" then
          [ "/dev/nvme0n1 r" ]
        else if hostname == "klusteri-1" then
          [ "/dev/nvme0n1 r" ]
        else if hostname == "klusteri-2" then
          [ "/dev/nvme0n1 r" ]
        else if hostname == "serveri" then
          [
            "/dev/nvme0n1 r"
            "/dev/sda r"
            "/dev/sdb r"
            "/dev/dm-1 r"
          ]
        else
          [ ]
      );
      PrivateDevices = false;

      KeyringMode = "private";
      LockPersonality = true;
      NoNewPrivileges = true;
      ProtectClock = true;
      ProtectHome = "read-only";
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictSUIDSGID = true;
    };

    wantedBy = [ "multi-user.target" ];
  };
  networking.firewall.allowedTCPPorts = [ 45876 ];
}
