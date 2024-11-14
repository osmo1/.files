{ pkgs, lib, ... }: {
  home-manager.users.osmo = {
    programs.alacritty = {
        enable = true;
        package = pkgs.alacritty;
        settings = {
            window.blur = true;
            font = {
#size = 14;
                normal.family = lib.mkForce "FiraCode Nerd Font";
                bold = {
                    family = "FiraCode Nerd Font";
                    style = "Bold";
                };
                italic = {
                    family = "FiraCode Nerd Font";
                    style = "Italic";
                };
                bold_italic = {
                    family = "FiraCode Nerd Font";
                    style = "Bold Italic";
                };
            };
        };
    };
  };
  users.users.osmo.packages = [ pkgs.alacritty-theme ];
}
