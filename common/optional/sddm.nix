{ pkgs, ... }:
let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ../../pkgs/sddm-tokyonight.nix { };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.sddm.theme = "tokyo-night-sddm";
  environment.systemPackages = with pkgs; [ tokyo-night-sddm ];
}
