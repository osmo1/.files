{
  home-manager.users.osmo =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        terminal = "tmux-256color";
        mouse = true;
        prefix = "C-Space";
        keyMode = "vi";
        clock24 = true;
        tmuxinator.enable = true;
        sensibleOnTop = true;
        plugins = [ ];
      };
    };
}
