{ pkgs, ... }: {
  home-manager.users.osmo = {
    programs.alacritty = {
        enable = true;
        settings.window.blur = true;
    };/*
        package = pkgs.alacritty;
            font = {
                size = 14;
                normal.family = "FiraCode Nerd Font";
                bold.family = "FiraCode Nerd Font";
                italic.family = "FiraCode Nerd Font";
                bold_italic.family = "FiraCode Nerd Font";
            };
        };
    };*/
  };
  users.users.osmo.packages = [ pkgs.alacritty-theme ];
}
