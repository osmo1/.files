{
home-manager.users.osmo = {}: {
xfconf.settings = {
xsettings = {
  "Net/ThemeName" = "Tokyonight-Dark-BL";
  "Net/IconThemeName" = "Papirus-Dark";
  "Net/DoubleClickTime" = null;
  "Net/DoubleClickDistance" = null;
  "Net/DndDragThreshold" = null;
  "Net/CursorBlink" = null;
  "Net/CursorBlinkTime" = null;
  "Net/SoundThemeName" = null;
  "Net/EnableEventSounds" = null;
  "Net/EnableInputFeedbackSounds" = null;

  "Xft/DPI" = null;
  "Xft/Antialias" = null;
  "Xft/Hinting" = null;
  "Xft/HintStyle" = null;
  "Xft/RGBA" = null;

  "Gtk/CanChangeAccels" = null;
  "Gtk/ColorPalette" = null;
  "Gtk/FontName" = null;
  "Gtk/MonospaceFontName" = null;
  "Gtk/IconSizes" = null;
  "Gtk/KeyThemeName" = null;
  "Gtk/ToolbarStyle" = null;
  "Gtk/ToolbarIconSize" = null;
  "Gtk/MenuImages" = null;
  "Gtk/ButtonImages" = null;
  "Gtk/MenuBarAccel" = null;
  "Gtk/CursorThemeName" = null;
  "Gtk/CursorThemeSize" = null;
  "Gtk/DecorationLayout" = null;
  "Gtk/DialogsUseHeader" = null;
  "Gtk/TitlebarMiddleClick" = null;

  "Gdk/WindowScalingFactor" = null;

  "Xfce/SyncThemes" = true;
};
xfwm4 = {
  "general/activate_action" = "bring";
  "general/borderless_maximize" = true;
  "general/box_move" = false;
  "general/box_resize" = false;
  "general/button_layout" = "O|SHMC";
  "general/button_offset" = 0;
  "general/button_spacing" = 0;
  "general/click_to_focus" = true;
  "general/cycle_apps_only" = false;
  "general/cycle_draw_frame" = true;
  "general/cycle_raise" = false;
  "general/cycle_hidden" = true;
  "general/cycle_minimum" = true;
  "general/cycle_minimized" = false;
  "general/cycle_preview" = true;
  "general/cycle_tabwin_mode" = 0;
  "general/cycle_workspaces" = false;
  "general/double_click_action" = "maximize";
  "general/double_click_distance" = 5;
  "general/double_click_time" = 250;
  "general/easy_click" = "Alt";
  "general/focus_delay" = 250;
  "general/focus_hint" = true;
  "general/focus_new" = true;
  "general/frame_opacity" = 100;
  "general/frame_border_top" = 0;
  "general/full_width_title" = true;
  "general/horiz_scroll_opacity" = false;
  "general/inactive_opacity" = 100;
  "general/maximized_offset" = 0;
  "general/mousewheel_rollup" = true;
  "general/move_opacity" = 100;
  "general/placement_mode" = "center";
  "general/placement_ratio" = 20;
  "general/popup_opacity" = 100;
  "general/prevent_focus_stealing" = false;
  "general/raise_delay" = 250;
  "general/raise_on_click" = true;
  "general/raise_on_focus" = false;
  "general/raise_with_any_button" = true;
  "general/repeat_urgent_blink" = false;
  "general/resize_opacity" = 100;
  "general/scroll_workspaces" = true;
  "general/shadow_delta_height" = 0;
  "general/shadow_delta_width" = 0;
  "general/shadow_delta_x" = 0;
  "general/shadow_delta_y" = -3;
  "general/shadow_opacity" = 50;
  "general/show_app_icon" = false;
  "general/show_dock_shadow" = true;
  "general/show_frame_shadow" = true;
  "general/show_popup_shadow" = false;
  "general/snap_resist" = false;
  "general/snap_to_border" = true;
  "general/snap_to_windows" = false;
  "general/snap_width" = 10;
  "general/vblank_mode" = "auto";
  "general/theme" = "Tokyonight-Dark-BL";
  "general/tile_on_move" = true;
  "general/title_alignment" = "center";
  "general/title_font" = "Sans Bold 9";
  "general/title_horizontal_offset" = 0;
  "general/titleless_maximize" = false;
  "general/title_shadow_active" = "false";
  "general/title_shadow_inactive" = "false";
  "general/title_vertical_offset_active" = 0;
  "general/title_vertical_offset_inactive" = 0;
  "general/toggle_workspaces" = false;
  "general/unredirect_overlays" = true;
  "general/urgent_blink" = false;
  "general/use_compositing" = true;
  "general/workspace_count" = 4;
  "general/wrap_cycle" = true;
  "general/wrap_layout" = true;
  "general/wrap_resistance" = 10;
  "general/wrap_windows" = true;
  "general/wrap_workspaces" = false;
  "general/zoom_desktop" = true;
  "general/zoom_pointer" = true;
  "general/workspace_names" = [
    "Workspace 1"
    "Workspace 2"
    "Workspace 3"
    "Workspace 4"
  ];
};
xfce4-session = {
  "general/FailsafeSessionName" = null;
  "general/LockCommand" = null;
  "general/SessionName" = "Default";
  "general/SaveOnExit" = false;

  "sessions/Failsafe/IsFailsafe" = null;
  "sessions/Failsafe/Count" = null;
  "sessions/Failsafe/Client0_Command" = null;
  "sessions/Failsafe/Client0_Priority" = null;
  "sessions/Failsafe/Client0_PerScreen" = null;
  "sessions/Failsafe/Client1_Command" = null;
  "sessions/Failsafe/Client1_Priority" = null;
  "sessions/Failsafe/Client1_PerScreen" = null;
  "sessions/Failsafe/Client2_Command" = null;
  "sessions/Failsafe/Client2_Priority" = null;
  "sessions/Failsafe/Client2_PerScreen" = null;
  "sessions/Failsafe/Client3_Command" = null;
  "sessions/Failsafe/Client3_Priority" = null;
  "sessions/Failsafe/Client3_PerScreen" = null;
  "sessions/Failsafe/Client4_Command" = null;
  "sessions/Failsafe/Client4_Priority" = null;
  "sessions/Failsafe/Client4_PerScreen" = null;
};
xfce4-panel = {
  "configver" = 2;
  "panels" = [ 
    1
    {
      "dark-mode" = true;
      "panel-1/position" = "p=6;x=0;y=0";
      "panel-1/length" = 100.0;
      "panel-1/position-locked" = true;
      "panel-1/icon-size" = 0;
      "panel-1/size" = 20;
      "panel-1/plugin-ids" = [ 1 2 3 4 5 6 9 10 11 12 13 14 ];
      "panel-1/mode" = 0;
      "panel-1/autohide-behavior" = 0;
      "panel-1/enable-struts" = true;
      "panel-1/nrows" = 1;
      "panel-1/background-style" = 0;
      "panel-1/enter-opacity" = 100;
      "panel-1/leave-opacity" = 100;
    }
  ];
  
  "plugins/plugin-1" = {
    "type" = "applicationsmenu";
    "show-generic-names" = false;
    "small" = false;
    "button-title" = "";
    "button-icon" = "distributor-logo-nixos";
    "custom-menu" = false;
  };

  "plugins/plugin-3" = {
    "type" = "separator";
    "expand" = true;
    "style" = 0;
  };

  "plugins/plugin-4" = "pager";

  "plugins/plugin-5" = {
    "type" = "separator";
    "style" = 0;
  };

  "plugins/plugin-6" = {
    "type" = "systray";
    "square-icons" = true;
    "known-legacy-items" = [
      "ethernet network connection “wired connection 1” active"
      "ethernet network connection “wired connection 1” active vpn connection active"
    ];
  };

  "plugins/plugin-9" = "power-manager-plugin";
  "plugins/plugin-10" = "notification-plugin";
  
  "plugins/plugin-11" = {
    "type" = "separator";
    "style" = 0;
  };
  
  "plugins/plugin-12" = {
    "type" = "clock";
    "mode" = 2;
    "digital-layout" = 3;
  };

  "plugins/plugin-13" = {
    "type" = "separator";
    "style" = 0;
  };

  "plugins/plugin-14" = {
    "type" = "actions";
    "button-title" = 3;
    "custom-title" = "Logout";
    "appearance" = 0;
    "items" = [
      "+lock-screen"
      "-switch-user"
      "-separator"
      "-suspend"
      "-hibernate"
      "-hybrid-sleep"
      "-separator"
      "+shutdown"
      "-restart"
      "-separator"
      "-logout"
      "+logout-dialog"
    ];
  };

  "plugins/plugin-2" = {
    "type" = "tasklist";
    "middle-click" = 1;
  };
};
xfce4-desktop = {
  "backdrop/screen0/monitorVirtual-1/workspace0/color-style" = 0;
  "backdrop/screen0/monitorVirtual-1/workspace0/image-style" = 5;
  "backdrop/screen0/monitorVirtual-1/workspace0/last-image" = inputs.wallpapers.stolen.nixos-tokyonight.path;

  "backdrop/screen0/monitorVirtual-1/workspace1/color-style" = 0;
  "backdrop/screen0/monitorVirtual-1/workspace1/image-style" = 5;
  "backdrop/screen0/monitorVirtual-1/workspace1/last-image" = inputs.wallpapers.stolen.nixos-tokyonight.path;

  "backdrop/screen0/monitorVirtual-1/workspace2/color-style" = 0;
  "backdrop/screen0/monitorVirtual-1/workspace2/image-style" = 5;
  "backdrop/screen0/monitorVirtual-1/workspace2/last-image" = inputs.wallpapers.stolen.nixos-tokyonight.path;

  "backdrop/screen0/monitorVirtual-1/workspace3/color-style" = 0;
  "backdrop/screen0/monitorVirtual-1/workspace3/image-style" = 5;
  "backdrop/screen0/monitorVirtual-1/workspace3/last-image" = inputs.wallpapers.stolen.nixos-tokyonight.path;
};
};
};
}
