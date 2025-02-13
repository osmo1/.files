{ inputs, ... }:
{
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      home.stateVersion = "24.05";
      home.sessionVariables = {
        XDG_RUNTIME_DIR = "/run/user/$UID";
      };
    };
  home-manager.backupFileExtension = "bk";
}
