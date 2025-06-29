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
          normal.family = lib.mkForce "ComicShannsMono Nerd Font";
          bold = {
            family = "ComicShannsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "ComicShannsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "ComicShannsMono Nerd Font";
            style = "Bold Italic";
          };
        };
      };
    };
  };
}
