{
  configLib,
  pkgs,
  callPackage,
  ...
}:
{
  imports = (configLib.scanPaths ./.) ++ [
    ../desktop
    ../thunar.nix
  ];
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";
  programs.xfconf.enable = true;
}
