{
  pkgs,
  lib,
  config,
  ...
}:
{

  imports = (lib.custom.scanPaths ./.) ++ [ ../core ];

  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.mutter ];
        extraGSettingsOverrides = ''
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer']
        '';
      };
      xkb = {
        layout = "fi";
        variant = "winkeys";
      };
    };
  };

  environment.gnome.excludePackages = (
    with pkgs.stable;
    [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]
  );
  environment.systemPackages =
    (with pkgs.stable; [
      gnome-settings-daemon
      ddcutil
      morewaita-icon-theme
    ])
    ++ (with pkgs.stable.gnomeExtensions; [
      appindicator
      blur-my-shell
      lockscreen-extension
      caffeine
      dash-to-dock
      displays-adjustments
      gsconnect
      openweather-refined
      status-area-horizontal-spacing
      quick-settings-tweaker
      impatience
      alphabetical-app-grid
      just-perfection
    ]);
  services.dbus.packages = with pkgs.stable; [ gnome2.GConf ]; # Shouldn't matter
  services.sysprof.enable = true;
  # home-manager.users."${config.hostSpec.username}" = {
  home-manager.users.osmo = {
    dconf = {
      enable = true;
      settings = with lib.gvariant; {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.stable.gnomeExtensions; [
            "user-theme@gnome-shell-extensions.gcampax.github.com"
            blur-my-shell.extensionUuid
            appindicator.extensionUuid
            lockscreen-extension.extensionUuid
            caffeine.extensionUuid
            dash-to-dock.extensionUuid
            displays-adjustments.extensionUuid
            gsconnect.extensionUuid
            openweather-refined.extensionUuid
            status-area-horizontal-spacing.extensionUuid
            quick-settings-tweaker.extensionUuid
            impatience.extensionUuid
            alphabetical-app-grid.extensionUuid
            just-perfection.extensionUuid
          ];
          favorite-apps = [
            "zen.desktop"
            "Alacritty.desktop"
            "org.gnome.Nautilus.desktop"
            "steam.desktop"
            "spotify.desktop"
          ];
          last-selected-power-profile = "performance";
          welcome-dialog-last-shown-version = "48.2";
        };

        "org/gnome/shell/extensions/blur-my-shell" = {
          brightness = 0.75;
          noise-amount = 0;
          settings-version = 2;
        };

        "org/gnome/desktop/input-sources" = {
          sources = [
            (mkTuple [
              "xkb"
              "fi+winkeys"
            ])
          ];
          xkb-options = [ "esc:nocaps" ];
        };

        "desktop/ibus/panel" = {
          custom-icon = "breeze-dark";
          custom-theme = "Breeze-Dark";
          use-custom-icon = true;
          use-custom-theme = true;
        };

        "io/gitlab/idevecore/Pomodoro" = {
          is-maximized = true;
          play-sounds = false;
          timer-break-sound = ''
            {"type":"freedesktop","uri":"complete","repeat":1}
          '';
          timer-finish-sound = ''
            {"type":"freedesktop","uri":"alarm-clock-elapsed","repeat":1}
          '';
          timer-start-sound = ''
            {"type":"freedesktop","uri":"message-new-instant","repeat":1}
          '';
        };

        "org/gnome/Console" = {
          last-window-maximised = false;
        };

        "org/gnome/TextEditor" = {
          style-scheme = "stylix";
        };

        "org/gnome/control-center" = {
          last-panel = "system";
        };

        "org/gnome/desktop/a11y/applications" = {
          screen-reader-enabled = false;
        };

        "org/gnome/desktop/app-folders/folders/Utilities" = {
          apps = [
            "org.gnome.FileRoller.desktop"
            "org.gnome.Loupe.desktop"
            "org.gnome.seahorse.Application.desktop"
            "org.gnome.font-viewer.desktop"
            "org.gnome.Connections.desktop"
          ];
          name = "X-GNOME-Shell-Utilities.directory";
          translate = true;
        };

        "org/gnome/desktop/app-folders/folders/YaST" = {
          categories = [ "X-SuSE-YaST" ];
          name = "suse-yast.directory";
          translate = true;
        };

        "org/gnome/desktop/background" = {
          color-shading-type = "solid";
          picture-options = "zoom";
        };

        "org/gnome/desktop/break-reminders/movement" = {
          duration-seconds = mkUint32 300;
          interval-seconds = mkUint32 1800;
          play-sound = true;
        };

        "org/gnome/desktop/interface" = {
          accent-color = "slate";
          color-scheme = "prefer-dark";
          toolbar-style = "text";
        };

        "org/gnome/desktop/notifications" = {
          application-children = [
            "zen"
            "org-gnome-shell-extensions-gsconnect"
          ];
          show-banners = false;
          show-in-lock-screen = true;
        };

        "org/gnome/desktop/notifications/application/org-gnome-shell-extensions-gsconnect" = {
          application-id = "org.gnome.Shell.Extensions.GSConnect.desktop";
        };

        "org/gnome/desktop/notifications/application/zen" = {
          application-id = "zen.desktop";
        };

        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
        };

        "org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
          speed = 0.10924369747899165;
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          two-finger-scrolling-enabled = true;
        };

        "org/gnome/desktop/privacy" = {
          disable-camera = true;
          remember-recent-files = false;
        };

        "org/gnome/desktop/search-providers" = {
          enabled = [ "org.gnome.Weather.desktop" ];
          sort-order = [
            "org.gnome.Settings.desktop"
            "org.gnome.Contacts.desktop"
            "org.gnome.Nautilus.desktop"
          ];
        };

        "org/gnome/desktop/session" = {
          idle-delay = mkUint32 0;
        };

        "org/gnome/desktop/sound" = {
          event-sounds = false;
          theme-name = "__custom";
        };

        "org/gnome/desktop/wm/keybindings" = {
          switch-applications = [ ];
          switch-applications-backward = [ ];
          switch-to-workspace-left = [ "<Control><Super>Left" ];
          switch-to-workspace-right = [ "<Control><Super>Right" ];
          switch-windows = [ "<Alt>Tab" ];
          switch-windows-backward = [ "<Shift><Alt>Tab" ];
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = "icon:minimize,maximize,close";
        };

        "org/gnome/eog/view" = {
          background-color = "#1f1f28";
        };

        "org/gnome/evolution-data-server" = {
          migrated = true;
        };

        "org/gnome/mutter" = {
          output-luminance = [
            (mkTuple [
              "DP-3"
              "GBT"
              "G32QC"
              "20170B001487"
              (mkUint32 1)
              39.79166666666667
            ])
          ];
        };

        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "icon-view";
          migrated-gtk-settings = true;
          search-filter-time-type = "last_modified";
        };

        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = false;
          night-light-schedule-from = 22.0;
          night-light-temperature = mkUint32 2232;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
        };

        "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
          app-switcher-popup-filter = 1;
          app-switcher-popup-hide-win-counter-for-single-window = false;
          app-switcher-popup-search-pref-running = true;
          app-switcher-popup-sorting = 2;
          app-switcher-popup-titles = true;
          app-switcher-popup-win-counter = true;
          hot-edge-pressure = 100;
          show-dash = 0;
          switcher-popup-preview-selected = 1;
          switcher-popup-sync-filter = false;
          switcher-ws-thumbnails = 0;
          win-switch-include-modals = true;
          win-switch-mark-minimized = true;
          win-switch-minimized-to-end = false;
          win-switch-skip-minimized = false;
          win-switcher-popup-filter = 2;
          win-switcher-popup-order = 1;
          win-switcher-popup-search-all = true;
          win-switcher-popup-search-apps = true;
          win-switcher-popup-sorting = 1;
        };

        "org/gnome/shell/extensions/appindicator" = {
          icon-brightness = 0.0;
          icon-contrast = 0.0;
          icon-opacity = 240;
          icon-saturation = 0.0;
          icon-size = 0;
        };

        "org/gnome/shell/extensions/auto-adwaita-colors" = {
          accent-color = "slate";
          notify-about-releases = false;
        };

        "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
          brightness = 0.75;
          sigma = 30;
        };

        "org/gnome/shell/extensions/blur-my-shell/applications" = {
          blur = true;
          blur-on-overview = false;
          brightness = 0.8;
          dynamic-opacity = false;
          enable-all = false;
          opacity = 200;
          sigma = 30;
          whitelist = [ "Alacritty" ];
        };

        "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
          pipeline = "pipeline_default";
        };

        "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
          blur = true;
          brightness = 0.61;
          pipeline = "pipeline_default_rounded";
          sigma = 49;
          static-blur = true;
          style-dash-to-dock = 0;
          unblur-in-overview = false;
        };

        "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
          pipeline = "pipeline_default";
        };

        "org/gnome/shell/extensions/blur-my-shell/overview" = {
          pipeline = "pipeline_default";
        };

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          brightness = 0.75;
          pipeline = "pipeline_default";
          sigma = 30;
          static-blur = true;
        };

        "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
          pipeline = "pipeline_default";
        };

        "org/gnome/shell/extensions/blur-my-shell/window-list" = {
          brightness = 0.75;
          sigma = 30;
        };

        "org/gnome/shell/extensions/caffeine" = {
          enable-mpris = true;
          indicator-position-max = 2;
          prefs-default-height = 1405;
          prefs-default-width = 1256;
          show-indicator = "never";
          user-enabled = true;
        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          background-opacity = 0.8;
          dash-max-icon-size = 48;
          dock-position = "BOTTOM";
          height-fraction = 0.9;
          preferred-monitor = -2;
          preferred-monitor-by-connector = "DP-3";
          show-mounts = false;
          show-trash = false;
        };

        "org/gnome/shell/extensions/gsconnect" = {
          devices = [ "C48D3C4344BB4F0D8C4F409EE3B8B903" ];
          keep-alive-when-locked = true;
          name = "masiina";
        };

        "org/gnome/shell/extensions/gsconnect/device/C48D3C4344BB4F0D8C4F409EE3B8B903" = {
          incoming-capabilities = [
            "kdeconnect.battery"
            "kdeconnect.battery.request"
            "kdeconnect.clipboard"
            "kdeconnect.clipboard.connect"
            "kdeconnect.findmyphone.request"
            "kdeconnect.ping"
            "kdeconnect.runcommand"
            "kdeconnect.share.request"
            "kdeconnect.share.request.update"
          ];
          outgoing-capabilities = [
            "kdeconnect.battery"
            "kdeconnect.battery.request"
            "kdeconnect.clipboard"
            "kdeconnect.clipboard.connect"
            "kdeconnect.findmyphone.request"
            "kdeconnect.mousepad.request"
            "kdeconnect.ping"
            "kdeconnect.presenter"
            "kdeconnect.runcommand.request"
            "kdeconnect.share.request"
            "kdeconnect.share.request.update"
          ];
          paired = true;
          supported-plugins = [
            "battery"
            "clipboard"
            "findmyphone"
            "mousepad"
            "ping"
            "presenter"
            "runcommand"
            "share"
          ];
          type = "phone";
        };

        "org/gnome/shell/extensions/just-perfection" = {
          accent-color-icon = false;
          accessibility-menu = true;
          activities-button = true;
          alt-tab-icon-size = 0;
          alt-tab-small-icon-size = 0;
          animation = 1;
          calendar = true;
          clock-menu = true;
          clock-menu-position-offset = 0;
          dash = true;
          dash-app-running = true;
          dash-icon-size = 0;
          dash-separator = true;
          events-button = true;
          invert-calendar-column-items = false;
          keyboard-layout = false;
          looking-glass-height = 0;
          max-displayed-search-results = 0;
          osd = true;
          panel = true;
          panel-button-padding-size = 0;
          panel-icon-size = 12;
          panel-in-overview = true;
          panel-indicator-padding-size = 0;
          panel-notification-icon = false;
          panel-size = 24;
          power-icon = true;
          quick-settings = true;
          quick-settings-airplane-mode = false;
          quick-settings-dark-mode = false;
          quick-settings-night-light = false;
          ripple-box = true;
          screen-recording-indicator = true;
          screen-sharing-indicator = true;
          search = true;
          show-apps-button = true;
          startup-status = 1;
          support-notifier-showed-version = 34;
          support-notifier-type = 0;
          theme = false;
          weather = true;
          window-demands-attention-focus = false;
          window-menu-take-screenshot-button = false;
          window-picker-icon = false;
          window-preview-caption = true;
          window-preview-close-button = true;
          workspace = true;
          workspace-popup = true;
          workspace-switcher-size = 0;
          workspaces-in-app-grid = true;
          world-clock = true;
        };

        "org/gnome/shell/extensions/status-area-horizontal-spacing" = {
          hpadding = 4;
        };

        "org/gnome/shell/extensions/user-theme" = {
          name = "Stylix";
        };

        "org/gtk/gtk4/settings/color-chooser" = {
          custom-colors = [
            (mkTuple [
              1.0
              1.0
              0.0
              1.0
            ])
          ];
          selected-color = mkTuple [
            true
            0.14901961386203766
            0.6352941393852234
            0.4117647111415863
            1.0
          ];
        };

        "org/gtk/gtk4/settings/file-chooser" = {
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = false;
          sidebar-width = 140;
          sort-column = "name";
          sort-directories-first = true;
          sort-order = "ascending";
          type-format = "category";
          view-type = "list";
        };

        "org/gtk/settings/file-chooser" = {
          date-format = "regular";
          location-mode = "path-bar";
          show-hidden = true;
          show-size-column = true;
          show-type-column = true;
          sidebar-width = 254;
          sort-column = "modified";
          sort-directories-first = false;
          sort-order = "descending";
          type-format = "category";
        };

        "system/proxy" = {
          mode = "none";
        };
      };
    };
    stylix.iconTheme = {
      enable = true;
      # package = pkgs.stable.adwaita-icon-theme;
      # light = "Adwaita";
      # dark = "Adwaita";
      package = pkgs.stable.morewaita-icon-theme;
      light = "MoreWaita";
      dark = "MoreWaita";
    };
  };
}
