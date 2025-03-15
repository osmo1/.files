{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.restic;
in
{
  options.restic = {
    enable = mkEnableOption "Enable borgmatic backups";
    extraExcludes = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra excludes for the home directory";
    };
    extraBackups = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra backup configurations";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      restic-age = {
        owner = "osmo";
        group = "users";
        mode = "600";
      };
      "nixos/restic/ssh/private" = {
        path = "/home/osmo/.ssh/restic";
        owner = "osmo";
        group = "users";
        mode = "600";
      };
    };
    services.restic.backups = {
      main-backup = {
        paths = [ "/home/osmo" ];
        user = "osmo";
        exclude = [
          "/home/osmo/games"
          "/home/osmo/Games"
          "/home/osmo/.cache"
          "/home/osmo/.steam"
          "/home/osmo/.local/share/Steam"
        ] ++ cfg.extraExcludes;
        initialize = true;
        passwordFile = config.sops.secrets.restic-age.path;
        repository = "sftp:restic@192.168.11.12:/backups/${config.networking.hostName}-home";
        extraOptions = [ "sftp.command='ssh restic@192.168.11.12 -i /home/osmo/.ssh/restic -s sftp'" ];
        extraBackupArgs = [
          "--compression auto"
          "--read-concurrency 20"
        ];
        timerConfig = {
          OnCalendar = if config.hostSpec.isServer != true then "19:00" else "00:00";
          Persistent = true;
        };
        pruneOpts = [
          "--keep-last 3"
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 1"
        ];
      };
    } // cfg.extraBackups;

    systemd.services.restic-backups-main-backup.unitConfig.OnFailure = "notify-backup-failed.service";
    systemd.services."notify-backup-failed" = {
      enable = true;
      description = "Notify on failed backup";
      serviceConfig = {
        Type = "oneshot";
        User = config.users.users.osmo.name;
      };

      # required for notify-send
      environment.DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${toString config.users.users.osmo.uid}/bus";

      script = ''
        ${pkgs.libnotify}/bin/notify-send --urgency=critical \
          "Backup failed" \
          "$(journalctl -u restic-backups-daily -n 5 -o cat)"
      '';
    };
    environment.systemPackages = with pkgs; [
      restic
      libnotify
    ];
  };
}
