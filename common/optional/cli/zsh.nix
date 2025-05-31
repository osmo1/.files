{ pkgs, ... }:
{
  users.users.osmo.shell = pkgs.zsh;
  users.users.osmo.useDefaultShell = true;
  users.users.osmo.ignoreShellProgramCheck = true;
  home-manager.users.osmo =
    { config, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          cat = "bat";
          diff = "batdiff";
          man = "batman";
          less = "batpipe";
          grep = "rg";
          ll = "eza -l";
          ls = "eza";
          dua = "dua interactive";
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/.zsh/history";
        };

      };
    };
}
