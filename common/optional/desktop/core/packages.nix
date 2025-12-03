{ pkgs, config, ... }:
{
  users.users.osmo.packages =
    (with pkgs.stable; [
      # General
      ungoogled-chromium
      bitwarden-desktop
      wasistlos
      obsidian
      anytype
      libreoffice-qt6-fresh
      aseprite
      thunderbird
      anki
      element-desktop
      yubioath-flutter
      pomodoro-gtk
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
      vial
    ])
    ++ (with pkgs.unstable; [
      zed-editor
      # freecad-wayland
      #spotify
    ]);
  programs.kdeconnect.enable = (
    if config.services.desktopManager.gnome.enable == true then false else true
  );
}
