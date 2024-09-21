{ configLib, pkgs, callPackage, ... }: {
  imports = (configLib.scanPaths ./.) ++ 
  [
	  ../desktop
  ];
 services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";
}
