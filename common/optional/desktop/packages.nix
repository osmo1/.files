{ pkgs, inputs, ... }:
let
  zen-browser = pkgs.callPackage ../../../pkgs/zen-browser { };
in
{
  users.users.osmo.packages = 
    (with pkgs.stable; [
      # General
      alacritty
      wezterm
      zen-browser
      bitwarden
      whatsapp-for-linux
      obsidian
      #spotify
      spotifyd
      libreoffice-fresh
      vesktop

      # Coding
      vscodium # Needs further conf
      helix

      # Tools
      flameshot
      wireguard-tools
      capitaine-cursors
    ])
    ++ 
    (with pkgs.unstable; [
      zed-editor
    ]);
  programs.kdeconnect.enable = true;
}
