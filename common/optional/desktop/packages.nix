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
      libreoffice-fresh
      vesktop
      aseprite
      blender
      thunderbird
      anki

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
    ]);
  programs.kdeconnect.enable = true;
}
