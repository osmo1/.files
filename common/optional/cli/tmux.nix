{
  home-manager.users.osmo =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "xterm-256color";
        mouse = true;
        prefix = "C-Space";
        keyMode = "vi";
        clock24 = true;
        tmuxinator.enable = true;
        sensibleOnTop = true;
        newSession = true;
        historyLimit = 10000;
        plugins = [ ];
        extraConfig = "set -s escape-time 0
        set-option -g status-position top";
        disableConfirmationPrompt = true;
      };
    };
}
