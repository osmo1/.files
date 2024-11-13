{ configLib, pkgs, ... }:
{
  imports = (configLib.scanPaths ./.) ++ [ ../desktop ];
  environment.systemPackages =
    (with pkgs.stable; [
      dwl
      somebar
    ])

    ++

    (with pkgs.unstable; [
    ]);
}
