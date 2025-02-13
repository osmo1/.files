{
  home-manager.users.osmo =
    { config, ... }:
    {
      programs.starship = {
        enable = true;
        enableTransience = true;
        enableZshIntegration = true;
        settings = {

        };
        settings = {
          add_newline = false;
          format = "[](#9ece6a)$hostname[](bg:#9ece6a fg:#7dcfff)$directory[](fg:#7aa2f7 bg:#7dcfff)$git_branch$git_status[](fg:#bb9af7 bg:#7aa2f7)$nodejs$rust$golang$php[](fg:#bb9af7)\n$character";
          character = {
            success_symbol = "[󰘧](#9ece6a)";
            error_symbol = "[󰘧](#f7768e)";
          };
          hostname = {
            style = "fg:#1a1b26 bg:#9ece6a";
            format = "[ $hostname ]($style)";
            ssh_only = true;
          };
          directory = {
            style = "fg:#1a1b26 bg:#7dcfff";
            format = "[ $path ]($style)";
            truncation_length = 3;
            truncation_symbol = "…/";
          };
          directory.substitutions = {
            "Documents" = "󰈙 ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
            "Videos" = " ";
            #".files" = " ";
            "Games" = "󰖺 ";
            "Misc" = "󰫢 ";
            "~" = "";
          };
          git_branch = {
            symbol = "";
            style = "fg:#1a1b26 bg:#7aa2f7";
            format = "[ $symbol $branch ]($style)";
          };
          git_status = {
            style = "fg:#1a1b26 bg:#7aa2f7";
            format = "[($all_status$ahead_behind )]($style)";
          };
          rust = {
            symbol = "";
            style = "fg:#1a1b26 bg:#bb9af7";
            format = "[ $symbol($version) ]($style)";
          };
          c = {
            symbol = "";
            style = "fg:#1a1b26 bg:#bb9af7";
            format = "[ $symbol($version) ]($style)";
          };
          nodejs = {
            symbol = "";
            style = "fg:#1a1b26 bg:#bb9af7";
            format = "[ $symbol($version) ]($style)";
          };
          php = {
            symbol = "";
            style = "fg:#1a1b26 bg:#bb9af7";
            format = "[ $symbol($version) ]($style)";
          };
        };
      };
    };
}
