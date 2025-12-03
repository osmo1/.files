{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

let
  wallpapersPath = builtins.toString inputs.wallpapers;
in
{
  imports = (lib.custom.scanPaths ./.) ++ [
    ../core
    ../wm
  ];
  custom.programs.dwl = {
    enable = true;
    package = pkgs.stable.dwl;
    extraSessionCommands = "dwlb &";
    # export DISPLAY=":0"
    # export WAYLAND_DISPLAY="wayland-0"
  };

  systemd.user.services = {
    dwlb = {
      description = "Dwlb bar for dwl";
      wantedBy = [ "dwl-session.target" ];
      partOf = [ "dwl-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.writeShellScript "dwlb-status.sh" ''
          while ${pkgs.stable.procps}/bin/pidof ${pkgs.stable.dwl}/bin/dwl >/dev/null; do
            cpu_usage=$(${pkgs.stable.coreutils}/bin/env LANG=C ${pkgs.stable.procps}/bin/top -bn1 | ${pkgs.stable.gnugrep}/bin/grep "Cpu(s)" | ${pkgs.stable.gawk}/bin/awk '{print 100 - $8"%"}')
            ram_usage=$(${pkgs.stable.coreutils}/bin/env LANG=C ${pkgs.stable.procps}/bin/free -m | ${pkgs.stable.gawk}/bin/awk '/Mem:/ { printf("%.2f%%", $3/$2 * 100.0) }')
            disk_usage=$(${pkgs.stable.coreutils}/bin/df -h / | ${pkgs.stable.gawk}/bin/awk 'NR==2 {print $5}')
            system_time=$(${pkgs.stable.coreutils}/bin/date +"%Y-%m-%d %H:%M")
            battery_info=$(${pkgs.stable.acpi}/bin/acpi -b | ${pkgs.stable.gawk}/bin/awk '{print $4}' | ${pkgs.stable.gnused}/bin/sed 's/,//')
            cpu_temp=$(${pkgs.stable.lm_sensors}/bin/sensors | ${pkgs.stable.gawk}/bin/awk '/^Tctl:/ {print substr($2, 2)}')
            battery_level=$(${pkgs.stable.gnused}/bin/sed 's/%//' <<<"$battery_info")
            if [ -n "$battery_level" ]; then
              if [ "$battery_level" -gt 80 ]; then battery_icon=""
              elif [ "$battery_level" -gt 60 ]; then battery_icon=""
              elif [ "$battery_level" -gt 40 ]; then battery_icon=""
              elif [ "$battery_level" -gt 20 ]; then battery_icon=""
              else battery_icon=""; fi
            else
              battery_icon=""
            fi
            ${pkgs.stable.dwlb}/bin/dwlb -status all " $cpu_usage $cpu_temp |  $ram_usage |  $disk_usage | $battery_icon $battery_info | $system_time"
            ${pkgs.stable.coreutils}/bin/sleep 10
          done
        ''}";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };

    swaybg = {
      description = "Wallpaper setter for dwl via swaybg";
      wantedBy = [ "dwl-session.target" ];
      partOf = [ "dwl-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.stable.swaybg}/bin/swaybg -i ${wallpapersPath}/${config.hostSpec.wallpaper}
        '';
        Restart = "on-failure";
      };
    };
  };
}
