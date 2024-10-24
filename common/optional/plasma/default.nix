{ configLib, pkgs, ... }:
{
  imports = (configLib.scanPaths ./.) ++ [ ../desktop ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "fi";
      variant = "winkeys";
    };
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ oxygen ];
  services.displayManager.defaultSession = "plasma";
  home-manager.users.osmo =
    { inputs, ... }:
    {
      imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
      programs.plasma = {
        overrideConfig = true;
        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
          cursor = {
            theme = "capitaine-cursors";
            size = 24;
          };
          iconTheme = "Papirus-Dark";
        };
        panels = [
          # Bottom task-manager
          {
            location = "bottom";
            height = 44;
            lengthMode = "fit";
            hiding = "dodgewindows";
            floating = true;
            widgets = [
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General.launchers = [
                    "applications:librewolf.desktop"
                    "applications:org.kde.konsole.desktop"
                    "applications:org.kde.dolphin.desktop"
                  ];
                };
              }
            ];
          }
          # Top menubar
          {
            location = "top";
            height = 20;
            lengthMode = "fill";
            hiding = "none";
            floating = true;
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
                config = {
                  General.icon = "nix-snowflake-white";
                };
              }
              "org.kde.plasma.appmenu"
              "org.kde.plasma.panelspacer"
              {
                digitalClock = {
                  position = "besideTime";
                };
              }
              "org.kde.plasma.panelspacer"
              "org.kde.plasma.pager"
              {
                systemTray.items = {
                  shown = [ "org.kde.plasma.battery" ];
                  hidden = [ "org.kde.plasma.clipboard" ];
                };
              }
            ];
          }
        ];
        configFile = {
          "baloofilerc"."General"."dbVersion" = 2;
          "baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
          "baloofilerc"."General"."exclude filters version" = 9;
          "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
          "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
          "kactivitymanagerdrc"."activities"."c85a11b2-5b3c-4cde-82b4-f671d9fdd7f0" = "Work";
          "kactivitymanagerdrc"."activities"."f8f3555b-efa8-43ee-b0f6-c511464b68ec" = "Default";
          "kactivitymanagerdrc"."activities-icons"."c85a11b2-5b3c-4cde-82b4-f671d9fdd7f0" = "fcitx-handwriting-inactive";
          "kactivitymanagerdrc"."main"."currentActivity" = "f8f3555b-efa8-43ee-b0f6-c511464b68ec";
          "kcminputrc"."Libinput/1739/0/Synaptics TM3145-005"."ClickMethod" = 2;
          "kcminputrc"."Libinput/1739/0/Synaptics TM3145-005"."NaturalScroll" = true;
          "kcminputrc"."Libinput/1739/0/Synaptics TM3145-005"."ScrollMethod" = 1;
          "kcminputrc"."Libinput/2/10/TPPS\\/2 IBM TrackPoint"."PointerAccelerationProfile" = 1;
          "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat" = true;
          "kcminputrc"."Tmp"."update_info" = "delete_cursor_old_default_size.upd:DeleteCursorOldDefaultSize";
          "kded5rc"."Module-browserintegrationreminder"."autoload" = false;
          "kded5rc"."Module-device_automounter"."autoload" = false;
          "kded5rc"."PlasmaBrowserIntegration"."shownCount" = 1;
          "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "820,584";
          "kdeglobals"."General"."AccentColor" = "218,24,55";
          "kdeglobals"."General"."LastUsedCustomAccentColor" = "218,24,55";
          "kdeglobals"."KDE"."AnimationDurationFactor" = 0.5;
          "kdeglobals"."WM"."activeBackground" = "49,54,59";
          "kdeglobals"."WM"."activeBlend" = "252,252,252";
          "kdeglobals"."WM"."activeForeground" = "252,252,252";
          "kdeglobals"."WM"."inactiveBackground" = "42,46,50";
          "kdeglobals"."WM"."inactiveBlend" = "161,169,177";
          "kdeglobals"."WM"."inactiveForeground" = "161,169,177";
          "kwalletrc"."Wallet"."First Use" = false;
          "kwinrc"."Compositing"."AllowTearing" = false;
          "kwinrc"."Desktops"."Id_1" = "4de403c1-f531-4d51-b0ae-1199f8d072c5";
          "kwinrc"."Desktops"."Id_2" = "2a6e5d21-9197-45aa-8faa-1b28df21fa10";
          "kwinrc"."Desktops"."Name_1" = "Work";
          "kwinrc"."Desktops"."Name_2" = 2;
          "kwinrc"."Desktops"."Number" = 2;
          "kwinrc"."Desktops"."Rows" = 1;
          "kwinrc"."Effect-overview"."BorderActivate" = 9;
          "kwinrc"."ElectricBorders"."BottomRight" = "ShowDesktop";
          "kwinrc"."Input"."TabletMode" = "off";
          "kwinrc"."NightColor"."Active" = true;
          "kwinrc"."NightColor"."NightTemperature" = 3000;
          "kwinrc"."Tiling"."padding" = 4;
          "kwinrc"."Tiling/213a9620-187e-58a6-b80b-85d8fb95dfce"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
          "kwinrc"."Tiling/9af7dcb9-cc17-5e04-a97c-10654d6af592"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
          "kwinrc"."Xwayland"."Scale" = 1.25;
          "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
          "plasma-localerc"."Formats"."LC_ADDRESS" = "fi_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_MEASUREMENT" = "en_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_MONETARY" = "en_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_NAME" = "fi_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_NUMERIC" = "en_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_PAPER" = "en_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_TELEPHONE" = "fi_FI.UTF-8";
          "plasma-localerc"."Formats"."LC_TIME" = "en_FI.UTF-8";
          "plasmanotifyrc"."Notifications"."PopupTimeout" = 1942;
        };

      };
    };
}
