{ pkgs, ... }: {
  home-manager.users.osmo = {
    programs.alacritty = {
        enable = true;
        package = pkgs.alacritty;
        settings = {
            import = [ "${pkgs.alacritty-theme}/tokyo-night.toml" ];
            window = {
                opacity = 0.8;
                blur = true;
            };
            font = {
                size = 14;
                normal.family = "FiraCode Nerd Font";
                bold.family = "FiraCode Nerd Font";
                italic.family = "FiraCode Nerd Font";
                bold_italic.family = "FiraCode Nerd Font";
            };
        };
    };
  };
  users.users.osmo.packages = [ pkgs.alacritty-theme ];
}
