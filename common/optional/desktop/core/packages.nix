{ pkgs, config, ... }:
{
  users.users.osmo.packages =
    (with pkgs.stable; [
      # General
      ungoogled-chromium
      bitwarden
      whatsapp-for-linux
      obsidian
      anytype
      libreoffice-qt6-fresh
      aseprite
      blender
      thunderbird
      anki
      element-desktop
      yubioath-flutter
      pomodoro-gtk
      freecad-wayland
      speedcrunch
      rustdesk-flutter
      localsend

      # Coding
      vscodium # Needs further conf

      # Tools
      (flameshot.override { enableWlrSupport = true; })
      wireguard-tools
      capitaine-cursors
      xdg-desktop-portal-gtk
      openrgb
      pango
    ])
    ++ (with pkgs.unstable; [
      zed-editor
      #spotify
    ]);
  programs.kdeconnect.enable = (
    if config.services.xserver.desktopManager.gnome.enable == true then false else true
  );
}
