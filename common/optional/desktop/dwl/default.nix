{  pkgs, ... }:
let

  dbus-dwl = pkgs.writeShellScriptBin "dbus-dwl" ''
    "dbus-run-session ${pkgs.stable.dwl}/bin/dwl > ~/.dwl_info"
  '';
in
{
  # TODO: DOES NOT WORK!
  # I can't seem to get the configuration or the session control working.
  # Requires some nix wizardry skills that I don't yet have
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
    ])

    ++

      (with pkgs.unstable; [
      ]);
  services.displayManager.sessionPackages = [ pkgs.dwl ];
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
  environment.variables = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    #wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    #extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  home-manager.users.osmo =
    { config, ... }:
    {
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
      /*
        xdg.dataFile."dbus-1/services/fnott.service".text = ''
          [D-BUS Service]
          Name=org.freedesktop.Notifications
          Exec=${pkgs.fnott}/bin/fnott
          SystemdService=fnott.service
        '';
      */
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
        */

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
        */
      };
    };
}
