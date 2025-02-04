/*{
  pkgs,
  config,
  lib,
  ...
}:
let
  host = config.networking.hostName;
  borgbackupMonitor =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    {
      key = "borgbackupMonitor";
      _file = "borgbackupMonitor";
      config.systemd.services =
        {
          "notify-problems@" = {
            enable = true;
            serviceConfig.User = "osmo";
            environment.SERVICE = "%i";
            script = ''
                export $(cat /proc/$(${pkgs.procps}/bin/pgrep "plasmashell" -u "$USER")/environ | grep -z '^DBUS_SESSION_BUS_ADDRESS=')
                ${pkgs.kdialog}/bin/kdialog --error "$SERVICE FAILED! Run journalctl -u $SERVICE for details" --title "Service Failure"
            '';
          };
        }
        // flip mapAttrs' config.services.borgbackup.jobs (
          name: value:
          nameValuePair "borgbackup-job-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";
          }
        )
        // flip mapAttrs' config.services.borgbackup.jobs (
          name: value:
          nameValuePair "borgbackup-job-${name}" {
            unitConfig.OnFailure = "notify-problems@%i.service";
            preStart = lib.mkBefore ''
              # waiting for internet after resume-from-suspend
              until ${pkgs.unixtools.ping}/bin/ping google.com -c1 -q >/dev/null; do :; done
            '';
          }
        );
      # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
      # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
      config.systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
        name: value:
        nameValuePair "borgbackup-job-${name}" {
          timerConfig.Persistent = lib.mkForce true;
        }
      );
    };
in
{
  imports = [
    borgbackupMonitor
  ];
  services.borgbackup.jobs =
    let
      common-excludes = [
        # Largest cache dirs
        ".cache"
        "*/#cache2" # firefox
        #"*/Cache"
      /*];
      work-dirs =
        [
        ];
      basicBorgJob = name: {
        encryption.mode = "none";
        environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/osmo/.ssh/borgus";
        environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
        extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
        repo = "ssh://borgus@serveri:22//borgbackup/${name}";
        compression = "auto,zstd,1";
        startAt = "daily";
        user = "osmo";
      };
    in
    {
      home-osmo = basicBorgJob "${host}/home-osmo" // rec {
        paths = "/home/osmo";
        exclude =
          work-dirs
          ++ map (x: paths + "/" + x) (
            common-excludes
            ++ [
              "Downloads"
              "Games"
            ]
          );
      };
      home-osmo-downloads = basicBorgJob "${host}/home-osmo-downloads" // rec {
        paths = "/home/osmo/Downloads";
        exclude = map (x: paths + "/" + x) common-excludes;
      };
      /*
        extra-drive-important = basicBorgJob "backups/station/extra-drive-important" // rec {
          paths = "/media/extra-drive/important";
          exclude = map (x: paths + "/" + x) common-excludes;
        };
    };
  fileSystems."/run/user/1000/borg-home-osmo" = {
    device = "borgus@serveri:/borgbackup/${host}/home-osmo::${host}-home-osmo-2020-06-10T00:00:46";
    noCheck = true;
    fsType = "fuse.borgfs"; # note that this requires a custom binary, see below
    options = [
      "x-systemd.automount"
      "noauto"
      "uid=1002"
      "exec"
    ]; # I'm using automount here to skip mount on boot, which slows startup
  };
  # this one should mount the actual directory from the root view of backup
  fileSystems."/run/user/1000/home-osmo" = {
    device = "/run/user/1002/borg-home-osmo/home/osmo";
    options = [ "bind" ];
  };
  environment.systemPackages = [
    (pkgs.writeScriptBin "mount.fuse.borgfs" ''
      #!/bin/sh
      export BORG_RSH="ssh -o 'StrictHostKeyChecking=no' -i /home/osmo/.ssh/borgus"
      export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes
      export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes
      exec ${pkgs.borgbackup}/bin/borgfs "$@"
    '')
  ];
}*/
{ lib, config, ... }:
with lib;
let
  cfg = config.borgus;
in
{
  options.borgus = {
    enable = mkEnableOption "Enable borgmatic backups";
    extraPatterns = {
        type = types.list;
        default = [];
        description = "Extra patterns for the home directory";
    };
    extraBackups = {
        type = types.attrs;
        default = {};
        description = "Extra backup configurations";
    };
  };

  config = mkIf cfg.enable {
  home-manager.users.osmo = {
    sops.secrets.borgus = {
        user = "osmo";
        group = "users";
        mode = "600";
    };
    services.borgmatic = {
        enable = true;
        backups = {
            home = {
                location = {
                    sourceDirectories = [ "/home/osmo" ];
                    repositories = [ "ssh://borgus@192.168.11.12//${config.networking.hostName}-home" ];
                    excludeHomeManagerSymlinks = true;
                    patterns = [
                        "R /home/osmo"
                        "- Downloads"
                        # Largest cache dirs
                        "- home/osmo/.cache"
                        "- home/osmo/*/cache2" # firefox
                        "! home/osmo/.steam/steam/steamapps"
                    ] ++ cfg.borgus.extraPatterns;
                };
                storage.encryptionPasscommand = "cat ${config.sops.secrets.borgus.path}";
                consistency = {
                    checks = [
                      {
                        name = "repository";
                        frequency = "2 weeks";
                      }
                      {
                        name = "archives";
                        frequency = "4 weeks";
                      }
                      {
                        name = "data";
                        frequency = "6 weeks";
                      }
                    ];
                    extraConfig = {
                        skip_actions = {
                            checks = "extract";
                        };
                    };
                };
            };
        } // cfg.borgus.extraBackups;
    };
    };
    };
}
