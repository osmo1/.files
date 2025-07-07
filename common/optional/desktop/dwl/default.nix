{ pkgs, lib, ... }:
let
  dbus-dwl = pkgs.writeShellScriptBin "dbus-dwl" ''
    dbus-run-session -- bash -s << 'EOF'
      update_dwlb() {
        while ${pkgs.stable.procps}/bin/pidof ${pkgs.stable.dwl}/bin/dwl > /dev/null; do
          cpu_usage=$(${pkgs.coreutils}/bin/env LANG=C ${pkgs.procps}/bin/top -bn1 | ${pkgs.gnugrep}/bin/grep "Cpu(s)" | ${pkgs.gawk}/bin/awk '{print 100 - $8"%"}')
          ram_usage=$(${pkgs.coreutils}/bin/env LANG=C ${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk '/Mem:/ { printf("%.2f%%", $3/$2 * 100.0) }')
          disk_usage=$(${pkgs.stable.coreutils}/bin/df -h / | ${pkgs.stable.gawk}/bin/awk 'NR==2 {print $5}')
          system_time=$(${pkgs.stable.coreutils}/bin/date +"%Y-%m-%d %H:%M")
          battery_info=$(${pkgs.stable.acpi}/bin/acpi -b | ${pkgs.stable.gawk}/bin/awk '{print $4}' | ${pkgs.stable.gnused}/bin/sed 's/,//')
          cpu_temp=$(${pkgs.stable.lm_sensors}/bin/sensors | ${pkgs.stable.gawk}/bin/awk '/^Package id 0:/ {print $4}')
          battery_level=$(${pkgs.stable.gnused}/bin/sed 's/%//' <<<"$battery_info")
          if [ "$battery_level" -gt 80 ]; then battery_icon=""
          elif [ "$battery_level" -gt 60 ]; then battery_icon=""
          elif [ "$battery_level" -gt 40 ]; then battery_icon=""
          elif [ "$battery_level" -gt 20 ]; then battery_icon=""
          else battery_icon=""; fi
          dwlb -status all " $cpu_usage $cpu_temp |  $ram_usage |  $disk_usage | $battery_icon $battery_info | $system_time"
          ${pkgs.stable.coreutils}/bin/sleep 10
        done
      }
      update_dwlb &
      exec ${pkgs.stable.dwl}/bin/dwl -s dwlb
    EOF
    exit 0
  '';
in
{
  imports = (lib.custom.scanPaths ./.) ++ [ ../core ];
  environment.systemPackages =
    (with pkgs.stable; [
      dwl
      somebar
      dbus-dwl
      dconf
      kanshi
      blueman
      playerctl
      swayidle
      udiskie
      dwlb
    ])

    ++

      (with pkgs.unstable; [
      ]);

  # Needed for dwl (maybe?)
  environment.variables = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  # Add dwl to sddm
  services.displayManager = {
    sessionPackages = [ pkgs.stable.dwl ];
    sddm.settings.General.DefaultSession = "dwl.desktop";
  };

  programs.light.enable = true;
  /*
    services.gnome.gnome-keyring.enable = true;
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  */

  home-manager.users.osmo =
    { config, ... }:
    {
      # Bar
      programs = {
        bemenu = {
          enable = true;
          settings = {
            line-height = 28;
            prompt = "open";
            ignorecase = true;
          };
        };
      };
      /*
        systemd.user.targets = {
          dwl-session = {
            Unit = {
              Description = "dwl compositor session";
              Documentation = "man:systemd.special(7)";
              BindsTo = "graphical-session.target";
              Wants = "graphical-session-pre.target";
              After = "graphical-session-pre.target";
            };
          };
        };
          xdg.dataFile."dbus-1/services/fnott.service".text = ''
            [D-BUS Service]
            Name=org.freedesktop.Notifications
            Exec=${pkgs.fnott}/bin/fnott
            SystemdService=fnott.service
          '';
        systemd.user.services = {
          ## Notification daemon
          /*
            fnott = {
              Unit = {
                Description="Keyboard driven and lightweight Wayland notification daemon";
                Documentation="man:fnott(1) man:fnott.ini(5)";
                PartOf="graphical-session.target";
                After="graphical-session-pre.target";
              };

              Service = {
                Type="dbus";
                BusName="org.freedesktop.Notifications";
                ExecStart="${pkgs.fnott}/bin/fnott";
              };
            };

          ## Automatic display configuration
          kanshi = {
            Unit = {
              Description = "This is a Wayland equivalent for tools like autorandr.";
              Documentation = "man:kanshi(1) man:kanshi(5)";
              PartOf = "graphical-session.target";
            };

            Service = {
              Type = "simple";
              ExecStart = "${pkgs.stable.kanshi}/bin/kanshi";
            };

            Install.WantedBy = [ "dwl-session.target" ];
          };

          ## Bluetooth management
          blueman = {
            Unit = {
              Description = "Blueman is a GTK+ Bluetooth Manager";
              Documentation = "man:blueman-applet(1)";
              PartOf = "graphical-session.target";
            };

            Service = {
              Type = "simple";
              ExecStart = "${pkgs.blueman}/bin/blueman-applet";
            };
          };

          ## Music/video player controller
          playerctl = {
            Unit = {
              Description = "mpris media player command-line controller";
              Documentation = "man:playerctl(1)";
              PartOf = "graphical-session.target";
            };

            Service = {
              Type = "simple";
              ExecStart = "${pkgs.stable.playerctl}/bin/playerctld daemon";
            };

            Install.WantedBy = [ "dwl-session.target" ];
          };

          ## Swayidle for automatic locking
          swayidle = {
            Unit = {
              Description = "Idle manager for Wayland";
              Documentation = "man:swayidle(1)";
              PartOf = "graphical-session.target";
            };

            Service = {
              Type = "simple";
              ExecStart = ''
                ${pkgs.stable.swayidle}/bin/swayidle -w\
                  timeout 600 '/home/armeeh/Pkg/dwl/scripts/lock.sh' \
                  timeout 1200 'systemctl suspend-then-hibernate' \
                  before-sleep '/home/armeeh/Pkg/dwl/scripts/lock.sh'
              '';
            };

            Install.WantedBy = [ "dwl-session.target" ];
          };

          ## Udiskie for automounting drives
          udiskie = {
            Unit = {
              Description = "Automounter for removable media ";
              Documentation = "https://github.com/coldfix/udiskie/wiki";
              PartOf = "graphical-session.target";
            };

            Service = {
              Type = "simple";
              ExecStart = ''
                ${pkgs.stable.udiskie}/bin/udiskie
              '';
            };

            Install.WantedBy = [ "dwl-session.target" ];
          };

          ## Sway Audio Idle Inhibit
          # The pkgs.nur is a great idea
          /*
            sway-audio-idle-inhibit = {
              Unit = {
                Description="Automatically start idle inhibit when audio is playing";
                Documentation="https://github.com/ErikReider/SwayAudioIdleInhibit";
                PartOf="graphical-session.target";
              };

              Service = {
                Type="simple";
                ExecStart=''
                  ${pkgs.nur.repos."999eagle".swayaudioidleinhibit}/bin/sway-audio-idle-inhibit
                '';
              };

              Install.WantedBy = [ "dwl-session.target" ];
            };
        };
      */
    };
}
