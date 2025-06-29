{ pkgs, lib, ... }:
{
  home-manager.users.osmo = {
    programs.alacritty = {
      enable = true;
      package = pkgs.alacritty;
      settings = {
        window.blur = true;
        font = {
          #size = 14;
          normal.family = lib.mkForce "FiraMono Nerd Font";
          bold = {
            family = "FiraMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "FiraMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "FiraMono Nerd Font";
            style = "Bold Italic";
          };
        };
      };
    };
  };
  # users.users.osmo.packages = [ pkgs.alacritty-theme ];
}
