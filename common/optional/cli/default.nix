{ pkgs, lib, ... }:
{
  imports = (lib.custom.scanPaths ./.);
  environment.systemPackages =
    (with pkgs.stable; [
      ripgrep
      ripgrep-all
      nitch
      dua
      hyperfine
    ])
    ++ (with pkgs.unstable; [
    ]);
  home-manager.users.osmo.programs = {
    btop.enable = true;
    bat = {
      enable = true;
      extraPackages = with pkgs.stable.bat-extras; [ core ];
    };
    zellij.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    yazi = {
      enable = true;
    };
    ncspot = {
      enable = true;
      settings = {
        shuffle = true;
      };
    };
  };
}
