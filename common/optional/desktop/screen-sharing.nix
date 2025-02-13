{ pkgs, ... }:
{
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs.unstable; [
        #xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
        kdePackages.xdg-desktop-portal-kde
      ];
      #config.common.default = "*";
      configPackages = [ pkgs.unstable.xdg-desktop-portal-kde ];
    };
  };
  users.users.osmo.packages = with pkgs.unstable; [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];
}
