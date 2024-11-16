{
  home-manager.users.osmo = { config, ... }: {
        programs.zoxide = {
            enable = true;
            enableZshIntegration = true;
            options = [
              "--cmd cd"
            ];
        };
  };
}
