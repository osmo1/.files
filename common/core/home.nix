{ inputs, ... }:
{
  home-manager.users.osmo =
    { inputs, pkgs, ... }:
    {
      home.stateVersion = "24.05";
    };
    home-manager.backupFileExtension = "bk";
}
