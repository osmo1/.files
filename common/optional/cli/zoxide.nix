{
  home-manager.users.osmo = {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = [
          "--cmd cd"
        ];
      };
    };
}
