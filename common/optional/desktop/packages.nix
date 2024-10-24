{ pkgs, inputs, ... }:
let
  zen-browser = pkgs.callPackage ../../../pkgs/zen-browser { };
in
{
  users.users.osmo.packages = with pkgs; [
    # General
    alacritty
    zen-browser
    bitwarden
    whatsapp-for-linux
    obsidian
    spotify
    libreoffice-fresh
    vesktop
    
    # Coding
    vscodium # Needs further conf

    # Tools
    flameshot
    wireguard-tools
    capitaine-cursors
  ];
  programs.kdeconnect.enable = true;
}
