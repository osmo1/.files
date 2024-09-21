{ pkgs, ... }:
let 
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ./tokyo-night-sddm/default.nix { };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.displayManager.sddm.theme = "tokyo-night-sddm";
  environment.systemPackages = with pkgs; [ tokyo-night-sddm ];
}
