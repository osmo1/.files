{ pkgs, inputs, ... }:
let
  zen-browser = pkgs.callPackage ../../../../pkgs/zen-browser { };
in
{
  users.users.osmo.packages =
    (with pkgs.stable; [
      # General
      zen-browser
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
      flameshot
      wireguard-tools
      capitaine-cursors
      xdg-desktop-portal-gtk
      openrgb
    ])
    ++ (with pkgs.unstable; [
      zed-editor
      #spotify
    ]);
  programs.kdeconnect.enable = true;
}
