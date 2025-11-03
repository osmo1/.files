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
  systemd.services."beszel-agent" = {
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
      ]
      ++ (if hostname == "serveri" then [ "EXTRA_FILESYSTEMS=/home/osmo/data" ] else [ ]);
      Restart = "on-failure";
      RestartSec = 5;
      StateDirectory = "beszel-agent";

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
