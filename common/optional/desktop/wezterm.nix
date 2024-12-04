{ pkgs, ... }:
{
  home-manager.users.osmo = {
    programs.wezterm = {
      enable = true;
      package = pkgs.unstable.wezterm;
      enableZshIntegration = true;
      colorSchemes = {
        tokyoNight = {
          ansi = [
            "#15161e"
            "#f7768e"
            "#9ece6a"
            "#e0af68"
            "#7aa2f7"
            "#bb9af7"
            "#7dcfff"
            "#a9b1d6"
          ];
          brights = [
            "#414868"
            "#ff899d"
            "#9fe044"
            "#faba4a"
            "#8db0ff"
            "#c7a9ff"
            "#a4daff"
            "#c0caf5"
          ];
          background = "#1a1b26";
          cursor_bg = "#c0caf5";
          cursor_border = "#c0caf5";
          cursor_fg = "#1a1b26";
          foreground = "#c0caf5";
          selection_bg = "#283457";
          selection_fg = "#c0caf5";

        };
      };
      extraConfig = ''
        return {
          font = wezterm.font {
             family = "FiraCode Nerd Font",
             harfbuzz_features = { 'ss07', 'ss01', 'cv05', 'cv31', 'cv27' }
          },
          font_size = 14.5,
          hide_tab_bar_if_only_one_tab = true,
          color_scheme = "tokyoNight",
          window_background_opacity = 0.9,
        }
      '';
      #default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
    };
  };
}
