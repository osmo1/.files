{
  home-manager.users.osmo =
    { config, ... }:
    {
      fastfetch = {
        enable = true;
        settings = {
          modules = [
            "os"
            "host"
            "display"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "de"
            {
              type = "theme";
              key = (if config.hostSpec == "Tokyo Night" then "Tokyo Night" else "Kanagawa");
            }
            "terminal"
            "cpu"
            "gpu"
            "memory"
            "disk"
          ];
        };
      };
    };
}
