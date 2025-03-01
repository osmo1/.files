{ configLib, pkgs, ... }:
{
  imports = (configLib.scanPaths ./.);
  environment.systemPackages =
    (with pkgs.stable; [
    ])
    ++ (with pkgs.unstable; [
    ]);
  home-manager.users.osmo = {
      programs.btop.enable = true;
    };
}
