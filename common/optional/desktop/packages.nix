{ pkgs, inputs, ... }:
let
  zen-browser = pkgs.callPackage ../../../pkgs/zen-browser { };
in
{
  users.users.osmo.packages = 
    (with pkgs.stable; [
      # General
      zen-browser
      bitwarden
      whatsapp-for-linux
      obsidian
      libreoffice-fresh
      vesktop
      aseprite
      thunderbird
      rustdesk

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
    ++ 
    (with pkgs.unstable; [
      zed-editor
#spotify
    ]);
  programs.kdeconnect.enable = true;
}
