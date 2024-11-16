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
        enable = true;
        overrideConfig = true;
        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
          colorScheme = "untitled";
          cursor = {
            theme = "capitaine-cursors";
            size = 24;
          };
          iconTheme = "breeze-dark";
        };
        fonts = {
            toolbar = {
                family = "Hack Nerd Font";
                pointSize = 10;
            };
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
                    "applications:zen.desktop"
                    "applications:Alacritty.desktop"
                    "applications:org.kde.dolphin.desktop"
                    "applications:steam.desktop"
                    "applications:spotify.desktop"
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
                  shown = [ "org.kde.plasma.battery" "org.kde.plasma.volume" ];
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
          "kdeglobals"."General"."AccentColor" = "255,117,127";
          "kdeglobals"."General"."LastUsedCustomAccentColor" = "255,117,127";
          "kdeglobals"."KDE"."AnimationDurationFactor" = 0.5;
          "kdeglobals"."WM"."activeBackground" = "49,54,59";
          "kdeglobals"."WM"."activeBlend" = "252,252,252";
          "kdeglobals"."WM"."activeForeground" = "252,252,252";
          "kdeglobals"."WM"."inactiveBackground" = "42,46,50";
          "kdeglobals"."WM"."inactiveBlend" = "161,169,177";
          "kdeglobals"."WM"."inactiveForeground" = "161,169,177";
          "kdeglobals"."General"."XftHintStyle" = "hintslight";
          "kdeglobals"."General"."XftSubPixel" = "rgb";
          "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
          "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
          "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
          "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
          "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
          "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
          "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
          "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
          "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
          "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
          "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
          "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
          "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
          "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
          "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
          "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
          "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 140;
          "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
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
          "kwinrc"."Windows"."TitlebarDoubleClickCommand" = "Nothing";
          "kcminputrc"."Libinput/1133/49970/Logitech Gaming Mouse G502"."PointerAcceleration" = "-0.200";
          "kcminputrc"."Libinput/1133/49970/Logitech Gaming Mouse G502"."PointerAccelerationProfile" = 1;
          "kscreenlockerrc"."Daemon"."Autolock" = false;
          "kscreenlockerrc"."Daemon"."LockGrace" = 10;
          "kscreenlockerrc"."Daemon"."LockOnResume" = false;
          "kxkbrc"."Layout"."Options" = "caps:escape_shifted_capslock";
          "kxkbrc"."Layout"."ResetOldOptions" = true;
          "plasmanotifyrc"."Jobs"."PermanentPopups" = false;
          "plasmanotifyrc"."Notifications"."LowPriorityHistory" = true;
          "plasmanotifyrc"."Notifications"."LowPriorityPopups" = false;
          "plasmanotifyrc"."Notifications"."PopupTimeout" = 1000;
        };
      };
    };
}
