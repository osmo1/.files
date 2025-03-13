{ config, ... }:
let
  theme = (if config.hostSpec.theme == "Tokyo Night" then "Tokyo Night" else "Kanagawa");
in
{
  home-manager.users.osmo = {
    programs.fastfetch = {
      enable = true;
      settings = {
        modules = [
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "de"
          {
            type = "theme";
            format = theme;
          }
          "terminal"
          "cpu"
          "gpu"
          "display"
          "memory"
          "disk"
          "colors"
          {
            type = "custom";
            format = "";
          }
          {
            type = "custom";
            format = "";
          }
        ];
      };
    };
  };
}
