{ pkgs, ... }: {
    xdg = {
  portal = {
    enable = true;
    extraPortals = with pkgs.unstable; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
};
}
