{ pkgs, inputs, ... }:
let
  zen-browser = pkgs.callPackage ../../../pkgs/zen-browser { };
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
      cinny
      yubioath-flutter
      pomodoro-gtk
      freecad-wayland
      speedcrunch

      # Coding
      vscodium # Needs further conf
      helix

      # Tools
      flameshot
      wireguard-tools
      capitaine-cursors
      xdg-desktop-portal-gtk
      openrgb
    ])
    ++ (with pkgs.unstable; [
      zed-editor
      rustdesk-flutter
      #spotify
    ]) ++ [ inputs.ghostty.packages.x86_64-linux.default ];
  programs.kdeconnect.enable = true;
}
