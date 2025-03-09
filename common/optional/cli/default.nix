{ pkgs, lib, ... }:
{
  imports = (lib.custom.scanPaths ./.);
  environment.systemPackages =
    (with pkgs.stable; [
      ripgrep
      nitch
    ])
    ++ (with pkgs.unstable; [
    ]);
  home-manager.users.osmo = {
    programs.btop.enable = true;
    programs.bat.enable = true;
  };
}
