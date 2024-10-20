{ pkgs, pkgs-unstable, inputs, ... }:
let 
  zen-browser = pkgs.callPackage ../../../pkgs/zen-browser.nix { };
in
{
  users.users.osmo.packages = with pkgs; [
    wireguard-tools
    librewolf
    bitwarden
    thunderbird
    capitaine-cursors
    zen-browser
  ];
  #environment.packages = with pkgs; [ zen-browser ];
}
