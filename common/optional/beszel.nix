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
      ExecStart = "${lib.getExe' pkgs.stable.beszel "beszel-agent"}";
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
        # "DOCKER_HOST=\"http://localhost:2375\""
        "DOCKER_HOST=\"unix:///run/podman/podman.sock\""
        "LOG_LEVEL=debug"
        "PATH=/run/current-system/sw/bin"
      ]
      ++ (
        if hostname == "serveri" then
          [ "EXTRA_FILESYSTEMS=/dev/dm-1" ]
        else if
          lib.elem hostname [
            "klusteri-0"
            "klusteri-1"
            "klusteri-2"
          ]
        then
          [ "INTEL_GPU_DEVICE=drm:/dev/dri/card0" ]
        else
          [ ]
      );
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
          [
            "/dev/nvme0n1 r"
          ]
        else if hostname == "klusteri-1" then
          [
            "/dev/nvme0n1 r"
            "/dev/renderD128 r"
            "/dev/card0 r"
          ]
        else if hostname == "klusteri-2" then
          [
            "/dev/nvme0n1 r"
            "/dev/renderD128 r"
            "/dev/card0 r"
          ]
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

  environment.systemPackages =
    [ ]
    ++ (
      if
        lib.elem hostname [
          "klusteri-0"
          "klusteri-1"
          "klusteri-2"
        ]
      then
        [
          pkgs.stable.intel-gpu-tools
        ]
      else
        [ ]
    );
  security.wrappers = {
    smartctl = {
      source = "${lib.getExe pkgs.smartmontools}";
      owner = "root";
      group = "disk";
      permissions = "u=rwx,g=rwx,o=rx";
      capabilities = "cap_sys_rawio+ep";
    };
  }
  // (
    if
      lib.elem hostname [
        "klusteri-0"
        "klusteri-1"
        "klusteri-2"
      ]
    then
      {
        intel_gpu_top = {
          source = "${lib.getExe' pkgs.intel-gpu-tools "intel_gpu_top"}";
          capabilities = "cap_perfmon=ep";
          owner = "root";
          group = "root";
          permissions = "0755";
        };
      }
    else
      { }
  );
  boot.kernel.sysctl =
    { }
    // (

      if
        lib.elem hostname [
          "klusteri-0"
          "klusteri-1"
          "klusteri-2"
        ]
      then
        {
          "kernel.perf_event_paranoid" = 0;
        }
      else
        { }
    );
}
